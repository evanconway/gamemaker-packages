draw_set_color(c_white);
var _x = 300;
var _y = 300;
//draw_circle(_x, _y, 5, false);

var _mx = window_mouse_get_x();
var _my = window_mouse_get_y();
var _alignment = fa_center;

if (mx != _mx || my != _my) {
	using_mouse = true;
} else if (keyboard_check_pressed(vk_anykey)) {
	using_mouse = false;
}

if (selected_time >= 0) {
	if (--selected_time <= 0) {
		text_button_list_set_highlighted_option_selected(list, false);
		if (using_mouse) text_button_list_set_highlighted_at_xy(list, _x, _y, _mx, _my, _alignment);
	}
	
} else if (using_mouse) {
	text_button_list_set_highlighted_at_xy(list, _x, _y, _mx, _my, _alignment);
	if (mouse_check_button_pressed(mb_left)) {
		var _clicked_option_index = text_button_list_get_option_at_xy(list, _x, _y, _mx, _my, _alignment);
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

mx = _mx;
my = _my;

text_button_list_draw_vertical(list, _x, _y, _alignment);
