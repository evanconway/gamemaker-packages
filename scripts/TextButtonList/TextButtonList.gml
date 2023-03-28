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
	
	// experimental different strat
	highlighted_option_selected = false;
	
	reset_highlight_animation_on_change = true;
	
	reset_selected_animation_on_change = true;
	
	reset_default_animation_on_change = false;
}

/**
 * Sets the animation reset settings for default, highlight, and selected effects.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {bool} _reset_default
 * @param {bool} _reset_highlight
 * @param {bool} _reset_selected
 */
function text_button_list_set_animation_reset_options(_text_button_list, _reset_default, _reset_highlight, _reset_selected) {
	_text_button_list.reset_default_animation_on_change = _reset_default;
	_text_button_list.reset_highlight_animation_on_change = _reset_highlight;
	_text_button_list.reset_selected_animation_on_change = _reset_selected;
}

/**
 * Reset animation state of option at given index.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _option_index
 */
function text_button_list_reset_option_animations(_text_button_list, _option_index) {
	with (_text_button_list) {
		if (!reset_highlight_animation_on_change && !reset_selected_animation_on_change && !reset_default_animation_on_change) return;
		if (_option_index < 0 || _option_index >= array_length(options)) return;
		if (highlighted_option == _option_index && highlighted_option_selected && reset_selected_animation_on_change) {
			text_button_reset_animations_selected(options[_option_index]);
		} else if (highlighted_option == _option_index && reset_highlight_animation_on_change) {
			text_button_reset_animations_highlighted(options[_option_index]);
		} else if (reset_default_animation_on_change) {
			text_button_reset_animations_default(options[_option_index]);
		}
	}
}

/**
 * Resets the animations of the two given option indexes. But only if they differ.
 * This is mostly a utility function for resetting animations of newly changed
 * highlighted/selected option indexes.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _a
 * @param {real} _b
 */
function text_button_list_reset_two_animations(_text_button_list, _a, _b) {
	if (_a == _b) return;
	text_button_list_reset_option_animations(_text_button_list, _a);
	text_button_list_reset_option_animations(_text_button_list, _b);
}

/**
 * Return index of the highlighted option of the given text button list.
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_get_highlighted_option(_text_button_list) {
	return _text_button_list.highlighted_option;
}

/**
 * Set the highlighted option of given text button list to given selected state.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {bool} _selected
 */
function text_button_list_set_highlighted_option_selected(_text_button_list, _selected) {
	with (_text_button_list) {
		highlighted_option_selected = _selected;
		text_button_list_reset_option_animations(self, highlighted_option);
	}
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
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_highlight_previous(_text_button_list) {
	with (_text_button_list) {
		var _prev_highlighted = highlighted_option;
		highlighted_option--;
		highlighted_option = clamp(highlighted_option, 0, array_length(options) - 1);
		text_button_list_reset_two_animations(self, _prev_highlighted, highlighted_option);
	}
}

/**
 * Set highlighted option to next option.
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_highlight_next(_text_button_list) {
	with (_text_button_list) {
		var _prev_highlighted = highlighted_option;
		highlighted_option++;
		highlighted_option = clamp(highlighted_option, 0, array_length(options) - 1);
		text_button_list_reset_two_animations(self, _prev_highlighted, highlighted_option);
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
		var _new_highlight = text_button_list_get_option_at_xy(self, _list_x, _list_y, _x, _y, _alignment);
		if (_new_highlight == highlighted_option) return;
		var _prev_highlighted = highlighted_option;
		highlighted_option = _new_highlight;
		text_button_list_reset_two_animations(self, _prev_highlighted, highlighted_option);
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
			var _highlighted = highlighted_option == _d;
			var _selected = highlighted_option == _d && highlighted_option_selected;
			if (_alignment == fa_left) {
				text_button_draw(options[_d], _x, _y, _highlighted, _selected);
			}
			if (_alignment == fa_right) {
				text_button_draw(options[_d], _x - text_button_get_width(options[_d]), _y, _highlighted, _selected);
			}
			if (_alignment == fa_center) {
				text_button_draw(options[_d], _x - floor(text_button_get_width(options[_d]) / 2), _y, _highlighted, _selected);
			}
			_y += text_button_get_height(options[_d]);
		}	
	}
}
