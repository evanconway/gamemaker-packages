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
	
	calculate_xy = function() {
		// first pass: determine line breaks using line_index
		var _line_index = 0;
		var _line_width = 0;
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			_char.line_index = _line_index;
			_line_width += _char.get_width();
			if (_line_width >= width && _char.character != " ") {
				_line_index++;
				_line_width = 0;
				for (var _r = _i; character_array[_r].character != " " && _r >= 0; _r--) {
					character_array[_r].line_index = _line_index;
					_line_width += character_array[_r].get_width();
				}
			}
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
	
	// Mapping of character indexes to the drawable that draws them.
	character_drawables_map = ds_map_create();
	
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
				for (var _k = _index_start; _k <= _index_end; _k++) {
					ds_map_set(character_drawables_map, _k, _drawable);
				}
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
		for (var _k = _index_start; _k <= _index_end; _k++) {
			ds_map_set(character_drawables_map, _k, _drawable);
		}
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
	 * Splits the drawables linked list at the given indexes so a drawable starts at _index_start and one ends at _index_end.
	 * @param {real} _index_start
	 * @param {real} _index_end
	 */
	split_drawables_at = function(_index_start, _index_end) {
		var _left_drawable = ds_map_find_value(character_drawables_map, _index_start);
		if (_index_start > _left_drawable.get_index_start()) {
			var _drawable = new StyleableTextDrawable(character_array, _index_start, _left_drawable.get_index_end());
			_drawable.previous = _left_drawable;
			_drawable.next = _left_drawable.next;
			_left_drawable.next = _drawable;
			_left_drawable.set_index_end(_drawable.get_index_start() - 1);
			for (var _i = _left_drawable.get_index_start(); _i <= _left_drawable.get_index_end(); _i++) {
				ds_map_set(character_drawables_map, _i, _left_drawable);
			}
			for (var _i = _drawable.get_index_start(); _i <= _drawable.get_index_end(); _i++) {
				ds_map_set(character_drawables_map, _i, _drawable);
			}
		}
		var _right_drawable = ds_map_find_value(character_drawables_map, _index_end);
		if (_index_end < _right_drawable.get_index_end()) {
			var _drawable = new StyleableTextDrawable(character_array, _index_end + 1, _right_drawable.get_index_end());
			_drawable.previous = _right_drawable;
			_drawable.next = _right_drawable.next;
			_right_drawable.next = _drawable;
			_right_drawable.set_index_end(_drawable.get_index_start() - 1);
			for (var _i = _right_drawable.get_index_start(); _i <= _right_drawable.get_index_end(); _i++) {
				ds_map_set(character_drawables_map, _i, _right_drawable);
			}
			for (var _i = _drawable.get_index_start(); _i <= _drawable.get_index_end(); _i++) {
				ds_map_set(character_drawables_map, _i, _drawable);
			}
		}
	};
	
	/**
	 * Merges all drawables with given index range, as well as at the ends.
	 * @param {real} _index_start
	 * @param {real} _index_end
	 */
	merge_drawables_at = function(_index_start, _index_end) {
		var _merging_drawable = ds_map_find_value(character_drawables_map, _index_start);
		/*
		If drawable at _index_start begins with _index_start, we need to set it back to previous to
		make sure that _index_start is also merged. The only scenario we don't do this is if previous
		is undefined (the drawable is the start of the linked list).
		*/
		if (_merging_drawable.get_index_start() == _index_start && _merging_drawable.previous != undefined) {
			_merging_drawable = _merging_drawable.previous;
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
		ds_map_find_value(character_drawables_map, _index).sprite = _sprite;
	};
	
	set_scale_x = function(_index_start, _index_end, _scale_x) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = ds_map_find_value(character_drawables_map, _index_start);
		while (_cursor.get_index_end() <= _index_end) {
			_cursor.style.scale_x *= _scale_x;
			_cursor = _cursor.next;
		}
	};
	
	set_scale_y = function(_index_start, _index_end, _scale_y) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = ds_map_find_value(character_drawables_map, _index_start);
		while (_cursor.get_index_end() <= _index_end) {
			_cursor.style.scale_y *= _scale_y;
			_cursor = _cursor.next;
		}
	};
	
	set_font = function(_index_start, _index_end, _font) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = ds_map_find_value(character_drawables_map, _index_start);
		while (_cursor.get_index_end() <= _index_end) {
			_cursor.style.font = _font;
			_cursor = _cursor.next;
		}
	};
	
	set_color = function(_index_start, _index_end, _color) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = ds_map_find_value(character_drawables_map, _index_start);
		while (_cursor.get_index_end() <= _index_end) {
			_cursor.style.style_color = _color;
			_cursor = _cursor.next;
		}
	};
	
	set_alpha = function(_index_start, _index_end, _alpha) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = ds_map_find_value(character_drawables_map, _index_start);
		while (_cursor.get_index_end() <= _index_end) {
			_cursor.style.alpha *= _alpha;
			_cursor = _cursor.next;
		}
	};
	
	set_mod_x = function(_index_start, _index_end, _mod_x) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = ds_map_find_value(character_drawables_map, _index_start);
		while (_cursor.get_index_end() <= _index_end) {
			_cursor.style.mod_x += _mod_x;
			_cursor = _cursor.next;
		}
	};
	
	set_mod_y = function(_index_start, _index_end, _mod_y) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = ds_map_find_value(character_drawables_map, _index_start);
		while (_cursor.get_index_end() <= _index_end) {
			_cursor.style.mod_y += _mod_y;
			_cursor = _cursor.next;
		}
	};
	
	set_mod_angle = function(_index_start, _index_end, _mod_angle) {
		split_drawables_at(_index_start, _index_end);
		var _cursor = ds_map_find_value(character_drawables_map, _index_start);
		while (_cursor.get_index_end() <= _index_end) {
			_cursor.style.mod_angle += _mod_angle;
			_cursor = _cursor.next;
		}
	};
}
