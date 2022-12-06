/**
 * Get a new StyleableText instance.
 * @param {string} _source source string
 * @param {real} _width max width of text before line breaks occur
 */
function StyleableText(_source, _width = 500) constructor {
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
	
	drawables = undefined;
	calculate_default_drawables = function() {
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
	
	calculate_default_drawables();
	
	draw = function(_x, _y) {
		var _cursor = drawables;
		while (_cursor != undefined) {
			_cursor.draw(_x, _y);
			_cursor = _cursor.next;
		}
	};
	
	set_default_sprite = function(_index, _sprite) {
		character_array[_index].sprite = _sprite;
		calculate_default_drawables();
	};
	
	set_default_scale_x = function(_index_start, _index_end, _scale_x) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.scale_x = _scale_x;
		}
		calculate_default_drawables();
	};
	
	set_default_scale_y = function(_index_start, _index_end, _scale_y) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.scale_y = _scale_y;
		}
		calculate_default_drawables();
	};
	
	set_default_font = function(_index_start, _index_end, _font) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.font = _font;
		}
		calculate_default_drawables();
	};
	
	set_default_color = function(_index_start, _index_end, _color) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.style_color = _color;
		}
		calculate_default_drawables();
	};
	
	set_default_alpha = function(_index_start, _index_end, _alpha) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.alpha = _alpha;
		}
		calculate_default_drawables();
	};
	
	set_default_mod_x = function(_index_start, _index_end, _mod_x) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.mod_x = _mod_x;
		}
		calculate_default_drawables();
	};
	
	set_default_mod_y = function(_index_start, _index_end, _mod_y) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.mod_y = _mod_y;
		}
		calculate_default_drawables();
	};
	
	set_default_mod_angle = function(_index_start, _index_end, _mod_angle) {
		for (var _i = _index_start; _i <= _index_end; _i++) {
			character_array[_i].style.mod_angle = _mod_angle;
		}
		calculate_default_drawables();
	};
}
