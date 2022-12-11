/**
 * Get a new StyleableText instance.
 * @param {string} _source source string
 * @param {real} _width max width of text before line breaks occur
 */
function StyleableText(_source, _width = 600) constructor {
	if (string_length(_source) == 0) {
		show_error("Cannot create StyleableText with empty string!", true);
	}
	
	character_array = styleable_text_get_empty_array_character();
	for (var _i = 1; _i <= string_length(_source); _i++) {
		array_push(character_array, new StyleableTextCharacter(string_char_at(_source, _i)));
	}
	
	width = _width;
	
	/**
	 * Sets the line index for characters in the given range.
	 * @param {real} _index_start start index 
	 * @param {real} _index_end end index
	 * @param {real} _line_index the line index to give the characters
	 */
	characters_set_line_index = function(_index_start, _index_end, _line_index) {
		for (var _i = _index_start; _i <= _index_end; _i ++) {
			character_array[_i].line_index = _line_index;
		}
	};
	
	calculate_xy = function() {
		// first pass: determine line breaks using line_index
		var _line_index = 0;
		var _line_width = 0;
		var _word_index_start = 0;
		var _word_index_end = -1; // -1 if word has not started
		var _word_width = 0;
		
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			
			// if space, word is over
			if (_char.character == " ") {
				// if word is too big for line, start new line
				if (_line_width + _word_width > width) {
					_line_index++;
					_line_width = 0;
				}
				
				// add word to current line
				characters_set_line_index(_word_index_start, _word_index_end, _line_index);
				_line_width += _word_width;
				_word_width = 0;
				_word_index_end = -1; // mark word as not started
				
				// add space to current line
				characters_set_line_index(_i, _i, _line_index);
				_line_width += _char.get_width();
				
			// otherwise add to current word
			} else {
				// start new word if one has not been started
				if (_word_index_end < 0) _word_index_start = _i;
				_word_width += _char.get_width();
				_word_index_end = _i;
			}
		}
		
		// set last word line index
		if (_word_index_end <= 0) {
			// if word is too big for line, start new line
			if (_line_width + _word_width > width) {
				_line_index++;
				_line_width = 0;
			}
			
			// add word to current line
			characters_set_line_index(_word_index_start, _word_index_end, _line_index);
			_line_width += _word_width;
			_word_width = 0;
			_word_index_end = -1; // mark word as not started
		}
		
		// second pass: determine line heights
		var _line_heights = ds_map_create();
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			if (!ds_map_exists(_line_heights, _char.line_index)) {
				ds_map_set(_line_heights, _char.line_index, _char.get_height());
			} else {
				if (ds_map_find_value(_line_heights, _char.line_index) < _char.get_height()) {
					ds_map_set(_line_heights, _char.line_index, _char.get_height());
				}
			}
		}
		
		// third pass: set xy positions
		var _x = 0;
		var _y = 0;
		var _current_line_index = character_array[0].line_index;
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			if (_char.line_index != _current_line_index) {
				_x = 0;
				_y += ds_map_find_value(_line_heights, _current_line_index);
				_current_line_index = _char.line_index;
			}
			_char.position_x = _x;
			_x += _char.get_width();
			_char.position_y = _y;
		}
	};
	
	drawables = undefined;
	init_drawables = function() {
		calculate_xy();
		var _result = undefined;
		var _result_end = undefined;
		var _index_start = 0;
		var _index_end = 0;
		for (var _i = 1; _i < array_length(character_array); _i++) {
			var _char_checking = character_array[_i];
			var _char_against = character_array[_index_start];
			var _sprite_values_allow_merge = _char_checking.sprite == spr_styleable_text_sprite_default && _char_against.sprite == spr_styleable_text_sprite_default;
			var _style_values_allow_merge = _char_checking.style.is_equal(_char_against.style);
			var _line_indexes_allow_merge = _char_checking.line_index == _char_against.line_index;
			if (_sprite_values_allow_merge && _style_values_allow_merge && _line_indexes_allow_merge) {
				_index_end = _i;
			} else {
				var _drawable = new StyleableTextDrawable(character_array, _index_start, _index_end);
				if (_result == undefined) {
					_result = _drawable;
					_result_end = _drawable;
				} else {
					_result_end.next = _drawable;
					_drawable.previous = _result_end;
					_result_end = _drawable;
				}
				_index_start = _i;
				_index_end = _i;
			}
		}
		
		var _drawable = new StyleableTextDrawable(character_array, _index_start, _index_end);
		if (_result == undefined) {
			_result = _drawable;
			_result_end = _drawable;
		} else {
			_result_end.next = _drawable;
			_drawable.previous = _result_end;
			_result_end = _drawable;
		}
		
		drawables = _result;
	};
	
	init_drawables();
	
	/**
	 * Get the drawable instance that's drawing character at the given index.
	 * @param {real} _index character index
	 */
	get_drawable_for_character_at = function(_index) {
		var _cursor = drawables;
		while (_cursor != undefined) {
			if (_cursor.get_index_start() <= _index && _cursor.get_index_end() >= _index) return _cursor;
			_cursor = _cursor.next;
		}
		return _cursor;
	};
	
	/**
	 * Splits the drawables linked list at the given indexes so a drawable starts at _index_start and one ends at _index_end.
	 * @param {real} _index_start
	 * @param {real} _index_end
	 */
	split_drawables_at = function(_index_start, _index_end) {
		var _start_drawable = get_drawable_for_character_at(_index_start);
		_start_drawable.split_left_at_index(_index_start);
		var _end_drawable = get_drawable_for_character_at(_index_end);
		_end_drawable.split_right_at_index(_index_end);
		var _t = 0;
		// old version 
		/*
		var _left_drawable = get_drawable_for_character_at(_index_start);
		if (_index_start > _left_drawable.get_index_start()) {
			var _drawable = new StyleableTextDrawable(character_array, _index_start, _left_drawable.get_index_end());
			_drawable.previous = _left_drawable;
			_drawable.next = _left_drawable.next;
			_left_drawable.next = _drawable;
			_left_drawable.set_index_end(_drawable.get_index_start() - 1);
		}
		var _right_drawable = get_drawable_for_character_at(_index_start);
		if (_index_end < _right_drawable.get_index_end()) {
			var _drawable = new StyleableTextDrawable(character_array, _index_end + 1, _right_drawable.get_index_end());
			_drawable.previous = _right_drawable;
			_drawable.next = _right_drawable.next;
			_right_drawable.next = _drawable;
			_right_drawable.set_index_end(_drawable.get_index_start() - 1);
		}
		*/
	};
	
	/**
	 * Merges all drawables with given index range, as well as at the ends.
	 * @param {real} _index_start
	 * @param {real} _index_end
	 */
	merge_drawables_at = function(_index_start, _index_end) {
		var _merging_drawable = get_drawable_for_character_at(_index_start);
		/*
		If drawable at _index_start begins with _index_start, we need to set it back to previous to
		make sure that _index_start is also merged. The only scenario we don't do this is if previous
		is undefined (the drawable is the start of the linked list).
		*/
		if (_merging_drawable.get_index_start() == _index_start && _merging_drawable.previous != undefined) {
			_merging_drawable = _merging_drawable.previous;
		}
		/* 
		Now we merge drawables left -> right until the drawable we're merging has and end_index greater
		than the given, or end_index equals the given and next is undefined (at end of list).
		*/
		var _cursor = _merging_drawable;
		while (_cursor.get_index_end() < _index_end || _cursor.get_index_end() == _index_end && _cursor.next != undefined) {
			if (_cursor.can_merge_with_next()) {
				_cursor.merge_with_next();
			} else {
				_cursor = _cursor.next;
			}
		}
	}
	
	/**
	 * Draw this StyleableText instance at the given x and y positions.
	 * @param {real} _x x position
	 * @param {real} _y y position
	 */
	draw = function(_x, _y) {
		var _cursor = drawables;
		var _draw_calls = 0;
		while (_cursor != undefined) {
			_cursor.draw(_x, _y);
			_draw_calls++;
			_cursor = _cursor.next;
		}
		return _draw_calls;
	};
	
	// set default styles
	
	set_default_sprite = function(_index, _sprite) {
		character_array[_index].sprite = _sprite;
		init_drawables();
	};
	
	set_default_scale_x = function(_index_start, _index_end, _scale_x) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.scale_x = _scale_x;
		}
		init_drawables();
	};
	
	set_default_scale_y = function(_index_start, _index_end, _scale_y) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.scale_y = _scale_y;
		}
		init_drawables();
	};
	
	set_default_font = function(_index_start, _index_end, _font) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.font = _font;
		}
		init_drawables();
	};
	
	set_default_color = function(_index_start, _index_end, _color) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.style_color = _color;
		}
		init_drawables();
	};
	
	set_default_alpha = function(_index_start, _index_end, _alpha) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.alpha = _alpha;
		}
		init_drawables();
	};
	
	set_default_mod_x = function(_index_start, _index_end, _mod_x) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.mod_x = _mod_x;
		}
		init_drawables();
	};
	
	set_default_mod_y = function(_index_start, _index_end, _mod_y) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.mod_y = _mod_y;
		}
		init_drawables();
	};
	
	set_default_mod_angle = function(_index_start, _index_end, _mod_angle) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.mod_angle = _mod_angle;
		}
		init_drawables();
	};
	
	// affect temporary styles
	
	set_sprite = function(_index, _sprite) {
		split_drawables_at(_index, _index);
		get_drawable_for_character_at(_index).sprite = _sprite;
	};
	
	set_scale_x = function(_index_start, _index_end, _scale_x) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.scale_x *= _scale_x;
			_cursor = _cursor.next;
		}
	};
	
	set_scale_y = function(_index_start, _index_end, _scale_y) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.scale_y *= _scale_y;
			_cursor = _cursor.next;
		}
	};
	
	set_font = function(_index_start, _index_end, _font) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.font = _font;
			_cursor = _cursor.next;
		}
	};
	
	set_color = function(_index_start, _index_end, _color) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.style_color = _color;
			_cursor = _cursor.next;
		}
	};
	
	set_alpha = function(_index_start, _index_end, _alpha) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.alpha *= _alpha;
			_cursor = _cursor.next;
		}
	};
	
	set_mod_x = function(_index_start, _index_end, _mod_x) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.mod_x += _mod_x;
			_cursor = _cursor.next;
		}
	};
	
	set_mod_y = function(_index_start, _index_end, _mod_y) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.mod_y += _mod_y;
			_cursor = _cursor.next;
		}
	};
	
	set_mod_angle = function(_index_start, _index_end, _mod_angle) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = get_drawable_for_character_at(_index_start);
		while (_cursor != undefined && _cursor.get_index_end() <= _index_end) {
			_cursor.style.mod_angle += _mod_angle;
			_cursor = _cursor.next;
		}
	};
	
	/**
	 * Get if character at given index is hidden.
	 * @param {real} _index character index
	 */
	get_character_hidden = function(_index) {
		return character_array[_index].hidden;
	};
	
	/**
	 * Set hidden state of character at given index.
	 * @param {real} _index character index
	 * @param {bool} _hidden new hidden value of character
	 */
	set_character_hidden = function(_index, _hidden) {
		if (get_character_hidden(_index) == _hidden) return;
		split_drawables_at(_index, _index);
		character_array[_index].hidden = _hidden;
		merge_drawables_at(_index, _index);
	};
	
	/**
	 * @param {real} _index_start
	 * @param {real} _index_end
	 * @param {bool} _hidden
	 */
	set_characters_hidden = function(_index_start, _index_end, _hidden) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			set_character_hidden(_i, _hidden);
		}
	};
}
