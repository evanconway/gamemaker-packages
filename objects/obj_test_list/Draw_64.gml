draw_set_color(c_white);
var _x = 20;
var _y = 300;
draw_circle(_x, _y, 5, false);

var _mx = window_mouse_get_x();
var _my = window_mouse_get_y();
var _alignment = fa_left;

if (selected_time >= 0) {
	selected_time--;
} else {
	text_button_list_set_selected_option(list, -1);
	if (mx != _mx || my != _my) {
		text_button_list_set_highlighted_at_xy(list, _x, _y, _mx, window_mouse_get_y(), _alignment);
	} else {
		if (keyboard_check_pressed(vk_up)) text_button_list_highlight_previous(list);
		if (keyboard_check_pressed(vk_down)) text_button_list_highlight_next(list);
	}
	
	if (mouse_check_button_released(mb_left)) {
		var _clicked_option_index = text_button_list_get_option_at_xy(list, _x, _y, _mx, _my, _alignment);
		text_button_list_set_selected_option(list, _clicked_option_index);
		selected_time = 40;
	} else if (keyboard_check_pressed(vk_enter)) {
		var _entered_option_index = text_button_list_get_highlighted_option(list);
		text_button_list_set_selected_option(list, _entered_option_index);
		selected_time = 40;
	}
}

mx = _mx;
my = _my;

text_button_list_draw_vertical(list, _x, _y, _alignment);
