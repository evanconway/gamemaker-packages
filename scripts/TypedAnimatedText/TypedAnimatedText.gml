/**
 * @param {string} _source source string
 * @ignore
 */
function TypedAnimatedText(_source, _width, _height) constructor {
	animated_text = new AnimatedText(_source, _width, _height);
	animated_text.text.set_characters_hidden(0, animated_text.get_character_count() - 1, true);
	time_between_types_ms = 60;
	chars_per_type = 3;
	char_index_to_type = 0;
	time_ms = time_between_types_ms;
	
	// mapping between indexes of chars and array of entry animations for said chars
	entry_animations_map = ds_map_create();
	
	add_entry_animation_at = function(_index, _animation_enum, _aargs) {
		if (!ds_map_exists(entry_animations_map, _index)) ds_map_set(entry_animations_map, _index, []);
		array_push(ds_map_find_value(entry_animations_map, _index), { animation_enum: _animation_enum, aargs: _aargs });
	};
	
	/*
	To type a char, we check if there are any entry animations mapped to this char. If so we simply
	add a new animation of that type with associated aargs to the underlying animated_text instances.
	These animations handle visibility of the character themselves. If there is no animation mapped
	to the given character index we simply set the character visible.
	*/
	type_char_at = function(_index) {
		if (!ds_map_exists(entry_animations_map, _index)) {
			animated_text.text.set_character_hidden(_index, false);
			return;
		}
		var _animations = ds_map_find_value(entry_animations_map, _index);
		for (var _i = 0; _i < array_length(_animations); _i++) {
			animated_text.add_animation(_animations[_i].animation_enum, _index, _index, _animations[_i].aargs);
		}
	};
	
	/**
	 * @param {real} _update_time_ms amount of time in ms to update by
	 */
	update = function(_update_time_ms) {
		animated_text.update(_update_time_ms);
		if (char_index_to_type >= animated_text.get_character_count()) return;
		time_ms += _update_time_ms;
		if (time_ms < time_between_types_ms) return;
		time_ms = 0;
		var _can_type_chars = true;
		var _chars_typed = 0;
		while (_can_type_chars) {
			type_char_at(char_index_to_type);
			if (
				animated_text.get_char_at(char_index_to_type) == "." ||
				animated_text.get_char_at(char_index_to_type) == "!" ||
				animated_text.get_char_at(char_index_to_type) == "?" ||
				animated_text.get_char_at(char_index_to_type) == ":" ||
				animated_text.get_char_at(char_index_to_type) == ";" ||
				animated_text.get_char_at(char_index_to_type) == ","
			) {
				//time_ms = -400;
				_can_type_chars = false;
			}
			char_index_to_type++;
			_chars_typed++;
			while (char_index_to_type < animated_text.get_character_count() && animated_text.get_char_at(char_index_to_type) == " ") {
				type_char_at(char_index_to_type);
				char_index_to_type++;
			}
			if (char_index_to_type >= animated_text.get_character_count() || _chars_typed >= chars_per_type) {
				_can_type_chars = false;
			}
		}
	};
	
	reset_typing = function() {
		char_index_to_type = 0;
		animated_text.text.set_characters_hidden(0, animated_text.get_character_count() - 1, true);
		animated_text.reset_animations();
	}
	
	set_typed = function() {
		animated_text.text.set_characters_hidden(0, animated_text.get_character_count() - 1, false);
		animated_text.clear_entry_animations();
		char_index_to_type = animated_text.get_character_count();
	};
	
	get_typed = function() {
		return char_index_to_type = animated_text.get_character_count();
	}
	
	
	
	/**
	 * @param {real} _x x position
	 * @param {real} _y y position
	 * @param {real} _alignment horizontal alignment
	 */
	draw = function(_x, _y, _alignment = fa_left) {
		animated_text.draw(_x, _y, _alignment);
	};
	
	/**
	 * Returns an array of TypedAnimatedText instances each of which is a page of this instance split up
	 * based on the given dimensions.
	 * @param {real} _width
	 * @param {real} _height
	 */
	paginate = function(_width, _height) {
		// here we determine which line indexes of the underlying StyleableText instance go on what pages
		var _line_index_to_page_index_map = ds_map_create();
		var _line_index = 0;
		var _line_height = 0;
		var _page_height = 0;
		var _page_index = 0;
		for (var _i = 0; _i < array_length(animated_text.text.character_array); _i++) {
			var _char = (animated_text.text.character_array[_i]);
			if (_char.line_index != _line_index) {
				if (_page_height + _line_height < _height) {
					_page_height += _line_height;
				} else {
					_page_index++;
					_page_height = _line_height;
				}
				ds_map_set(_line_index_to_page_index_map, _line_index, _page_index);
				_line_index = _char.line_index;
				_line_height = _char.get_height();
			}
			_line_height = _char.get_height() > _line_height ? _char.get_height() : _line_height;
		}
		
		if (_page_height + _line_height >= _height) _page_index++;
		ds_map_set(_line_index_to_page_index_map, _line_index, _page_index);
		
		// create new arrays (1 for each page) of the characters
		var _new_char_arrays = [];
		for (var _i = 0; _i <= _page_index; _i++) array_push(_new_char_arrays, []);
		for (var _i = 0; _i < array_length(animated_text.text.character_array); _i++) {
			var _char = (animated_text.text.character_array[_i]);
			array_push(_new_char_arrays[ds_map_find_value(_line_index_to_page_index_map, _char.line_index)], _char);
		}
		
		/*
		Here is where the code gets very ugly. Since we didn't plan pagination in our original design we have to
		somehow force our underlying structure to match pages as if we'd created 3 separate TypedAnimatedText
		instances. Here we'll mess with variables that should be private to construct things properly.
		*/
		// create array of new StyleableText instances
		var _new_texts = [];
		var _entry_map_first_i = 0; // used for entry animations map
		var _entry_map_last_i = 0;
		for (var _i = 0; _i <= _page_index; _i++) {
			var _new_text = new TypedAnimatedText("$", _width, _height);
			
			// ensure inner StyleableText is correct
			_new_text.animated_text.text.character_array = _new_char_arrays[_i];
			_new_text.animated_text.text.init_drawables();
			
			// create a parsed down animation array that only includes animations which refer to characters in new char array
			var _last_char_array_index = array_length(_new_text.animated_text.text.character_array) - 1;
			for (var _k = 0; _k < array_length(animated_text.animations); _k++) {
				var _a = animated_text.animations[_k];
				if (_a.index_start <= _last_char_array_index) {
					var _new_end_index = _a.index_end > _last_char_array_index ? _last_char_array_index : _a.index_end;
					_new_text.animated_text.add_animation(_a.animation_enum_value, _a.index_start, _new_end_index, _a.params);
				}
				
				// peel back start and end indexes of animation to prep for next iteration
				_a.index_start -= _last_char_array_index;
				_a.index_start = _a.index_start < 0 ? 0 : _a.index_start;
				_a.index_end -= _last_char_array_index;
			}
			
			// filter out animations with negative end indexes (we've gone past them)
			/// @param {Struct.AnimatedTextAnimation}
			var _f = function(_anim_to_peel) {
				return _anim_to_peel.index_end >= 0;
			};
			animated_text.animations = array_filter(animated_text.animations, _f);
			
			// piece together the correct entry_animation_map for each new TypedAnimatedText instance
			_entry_map_last_i += _last_char_array_index;
			for (var _k = _entry_map_first_i; _k <= _entry_map_last_i; _k++) {
				if (ds_map_exists(entry_animations_map, _k)) {
					var _entry_anims = ds_map_find_value(entry_animations_map, _k);
					for (var _e = 0; _e < array_length(_entry_anims); _e++) {
						var _entry_anim = _entry_anims[_e];
						_new_text.add_entry_animation_at(_k - _entry_map_first_i, _entry_anim.animation_enum, _entry_anim.aargs);
					}
				}
			}
			
			_entry_map_first_i = _entry_map_last_i + 1;
			_entry_map_last_i = _entry_map_first_i;
			
			array_push(_new_texts, _new_text);
		}
		
		return _new_texts;
	};
	
	/*
	Feather doesn't like that we dynamically create animations during the draw/update events. It warns us about creating a bunch
	of instance variables during a non-create event. To solve this we're going to run a couple pointless lines here that
	trigger the same variable creation. This removes the warnings but doesn't change behavior.
	*/
	var _antifeather = new AnimatedText("the quick brown fox", -1, -1);
	_antifeather.add_animation(ANIMATED_TEXT_ANIMATIONS.CHROMATIC, 0, 0, []);
}
