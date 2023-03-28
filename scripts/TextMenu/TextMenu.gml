/**
 * Create a new TextMenu.
 * @param {array<string>} _options
 * @param {string} _default_effects
 * @param {string} _highlight_effects
 * @param {string} _selected_effects
 */
function TextMenu(_options, _default_effects = "gray", _highlight_effects = "yellow fade", _selected_effects = "lime") constructor{
	list = new TextButtonList(_options, _default_effects, _highlight_effects, _selected_effects);
	get_mouse_x = function() {
		return window_mouse_get_x();
	};
	
	get_mouse_y = function() {
		return window_mouse_get_y();
	};
	
	check_other_input = function() {
		return keyboard_check_pressed(vk_anykey);
	}
	
	previous_mx = get_mouse_x();
	previous_my = get_mouse_y();
	using_mouse = false;
	
	selected_time = -1;
}

/**
 * Update the given text menu. Animations are updated by the given update time in ms. Position and
 * alignment are required as well to determine button state.
 * @param {Struct.TextMenu} _text_menu
 * @param {real} _list_x
 * @param {real} _list_y
 * @param {Constant.HAlign} _alignment
 * @param {real} _update_time_ms
 */
function text_menu_update(_text_menu, _list_x, _list_y, _alignment = fa_left, _update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	with (_text_menu) {
		text_button_list_update(list, _update_time_ms);
		var _current_mx = get_mouse_x();
		var _current_my = get_mouse_y();
		if (previous_mx != _current_mx || previous_my != _current_my) using_mouse = true;
		else if (check_other_input()) using_mouse = false;
		
		if (selected_time >= 0) {
			if (--selected_time <= 0) {
				text_button_list_set_highlighted_option_selected(list, false);
				if (using_mouse) text_button_list_set_highlighted_at_xy(list, _list_x, _list_y, _current_mx, _current_my, _alignment);
			}
		} else if (using_mouse) {
			text_button_list_set_highlighted_at_xy(list, _list_x, _list_y, _current_mx, _current_my, _alignment);
			if (mouse_check_button_pressed(mb_left)) {
				var _clicked_option_index = text_button_list_get_option_at_xy(list, _list_x, _list_y, _current_mx, _current_my, _alignment);
				if (text_button_list_get_highlighted_option(list) == _clicked_option_index) text_button_list_set_highlighted_option_selected(list, true);
				selected_time = 40;
			}
		} else {
			if (keyboard_check_pressed(vk_up)) text_button_list_highlight_previous(list);
			if (keyboard_check_pressed(vk_down)) text_button_list_highlight_next(list);
			if (keyboard_check_pressed(vk_enter)) {
				var _entered_option_index = text_button_list_get_highlighted_option(list);
				if (text_button_list_get_highlighted_option(list) == _entered_option_index) text_button_list_set_highlighted_option_selected(list, true);
				selected_time = 40;
			}
		}

		previous_mx = _current_mx;
		previous_my = _current_my;
	}
	
}

/**
 * Draw the given text menu at the given xy, without updating state or text animations.
 * @param {Struct.TextMenu} _text_menu
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_menu_draw_vertical_no_update(_text_menu, _x, _y, _alignment = fa_left) {
	text_button_list_draw_vertical_no_update(_text_menu.list, _x, _y, _alignment);
}

/**
 * Draw the given text menu at the given xy. Also updates menu state and text animations.
 * @param {Struct.TextMenu} _text_menu
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_menu_draw_vertical(_text_menu, _x, _y, _alignment = fa_left) {
	text_menu_update(_text_menu, _x, _y, _alignment);
	text_menu_draw_vertical_no_update(_text_menu, _x, _y, _alignment);
}
