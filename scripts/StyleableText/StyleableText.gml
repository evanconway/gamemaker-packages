/**
 * Get a new StyleableText instance.
 * @param {string} _source source string
 * @param {real} _width max width of text before line breaks occur
 */
function StyleableText(_source, _width = 300) constructor {
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
	
	calculate_xy();
	
	draw = function(_x, _y) {
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			var _style = _char.style;
			var _draw_x = _x + _style.mod_x + _char.position_x;
			var _draw_y = _y + _style.mod_y + _char.position_y;
			if (_char.sprite == spr_styleable_text_sprite_default) {
				draw_set_font(_style.font);
				draw_set_alpha(_style.alpha);
				draw_set_color(_style.style_color);
				draw_text_transformed(_draw_x, _draw_y, _char.character, _style.scale_x, _style.scale_y, _style.mod_angle);
			} else {
				draw_sprite_ext(_char.sprite, 0, _draw_x, _char.position_y, _draw_x, _style.scale_y, _style.mod_angle, _style.style_color, _style.alpha);
			}
		}
	};
	
	
}
