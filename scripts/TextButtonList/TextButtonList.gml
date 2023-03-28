/**
 * Create a new text button list instance.
 * @param {array<string>} _options
 * @param {string} _default_effects
 * @param {string} _highlight_effects
 * @param {string} _selected_effects
 */
function TextButtonList(_options, _default_effects = "", _highlight_effects = "yellow fade", _selected_effects = "blink:0.6,1,50") constructor {
	/// @ignore
	options = [];
	
	for (var _i = 0; _i < array_length(_options); _i++) {
		array_push(options, new TextButton(_options[_i], _default_effects, _highlight_effects, _selected_effects));
	}
	
	/// @ignore
	width = 0;
	for (var _i = 0; _i < array_length(_options); _i++) {
		width += text_button_get_width(options[_i]);
	}
	
	/// @ignore
	height = 0;
	for (var _i = 0; _i < array_length(_options); _i++) {
		height += text_button_get_height(options[_i]);
	}
	
	/// @ignore
	highlighted_option = 0;
}

/**
 * Get width of given text button list.
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_get_width(_text_button_list) {
	return _text_button_list.width;
}

/**
 * Get height of given text button list.
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_get_height(_text_button_list) {
	return _text_button_list.height;
}

/**
 * Set highlighted option to previous option.
 */
function text_button_list_highlight_previous(_text_button_list) {
	with (_text_button_list) {
		highlighted_option--;
		highlighted_option = clamp(highlighted_option, 0, array_length(options) - 1);
	}
}

/**
 * Set highlighted option to next option.
 */
function text_button_list_highlight_next(_text_button_list) {
	with (_text_button_list) {
		highlighted_option++;
		highlighted_option = clamp(highlighted_option, 0, array_length(options) - 1);
	}
}

/**
 * Returns the index of the option in the given text button list that's at the given xy.
 * Returns -1 if no option as at given xy.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _list_x
 * @param {real} _list_y
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_get_option_at_xy(_text_button_list, _list_x, _list_y, _x, _y, _alignment = fa_left) {
	with (_text_button_list) {
		for (var _d = 0; _d < array_length(options); _d++) {
			var _selected = highlighted_option == _d;
			if (_alignment == fa_left) {
				if (text_button_is_point_on(options[_d], _list_x, _list_y, _x, _y)) return _d;
			}
			if (_alignment == fa_right) {
				if (text_button_is_point_on(options[_d], _list_x - text_button_get_width(options[_d]), _list_y, _x, _y)) return _d;
			}
			if (_alignment == fa_center) {
				if (text_button_is_point_on(options[_d], _list_x - floor(text_button_get_width(options[_d]) / 2), _list_y, _x, _y)) return _d
			}
			_list_y += text_button_get_height(options[_d]);
		}	
	}
	return -1;
}

/**
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _list_x
 * @param {real} _list_y
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_set_highlighted_at_xy(_text_button_list, _list_x, _list_y, _x, _y, _alignment = fa_left) {
	with (_text_button_list) {
		highlighted_option = text_button_list_get_option_at_xy(self, _list_x, _list_y, _x, _y, _alignment);
	}
}

/**
 * Draw given text button list in vertical fashion.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_draw_vertical(_text_button_list, _x, _y, _alignment = fa_left) {
	with (_text_button_list) {
		for (var _d = 0; _d < array_length(options); _d++) {
			var _selected = highlighted_option == _d;
			if (_alignment == fa_left) {
				text_button_draw(options[_d], _x, _y, _selected);
			}
			if (_alignment == fa_right) {
				text_button_draw(options[_d], _x - text_button_get_width(options[_d]), _y, _selected);
			}
			if (_alignment == fa_center) {
				text_button_draw(options[_d], _x - floor(text_button_get_width(options[_d]) / 2), _y, _selected);
			}
			_y += text_button_get_height(options[_d]);
		}	
	}
}
