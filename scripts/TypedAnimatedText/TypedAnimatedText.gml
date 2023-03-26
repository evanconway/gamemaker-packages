/**
 * @param {string} _source source string
 */
function TypedAnimatedText(_source) constructor {
	animated_text = new AnimatedText(_source);
	animated_text.text.set_characters_hidden(0, animated_text.get_character_count() - 1, true);
	time_between_types_ms = 60;
	chars_per_type = 5;
	char_index_to_type = 0;
	time_ms = time_between_types_ms;
	
	entry_animations_map = ds_map_create();
	
	add_entry_animation_at = function(_index, _animation_enum, _aargs) {
		if (!ds_map_exists(entry_animations_map, _index)) ds_map_set(entry_animations_map, _index, []);
		array_push(ds_map_find_value(entry_animations_map, _index), { animation_enum: _animation_enum, aargs: _aargs });
	};
	
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
				time_ms = -400;
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
	
	set_typed = function(_typed) {
		animated_text.text.set_characters_hidden(0, animated_text.get_character_count() - 1, !_typed);
		if (_typed) char_index_to_type = animated_text.get_character_count();
	};
	
	set_typed(true);
	
	/**
	 * @param {real} _x x position
	 * @param {real} _y y position
	 * @param {real} _alignment horizontal alignment
	 */
	draw = function(_x, _y, _alignment) {
		update(1000 / game_get_speed(gamespeed_fps));
		animated_text.draw(_x, _y, _alignment);
	};
}
