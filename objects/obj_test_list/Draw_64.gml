draw_set_color(c_white);
var _x = 400;
var _y = 300;
draw_circle(_x, _y, 5, false);

var _alignment = fa_center;

if (mx != window_mouse_get_x() || my != window_mouse_get_y()) {
	text_button_list_set_highlighted_at_xy(
		list,
		_x,
		_y,
		window_mouse_get_x(),
		window_mouse_get_y(),
		_alignment
	);
} else {
	if (keyboard_check_pressed(vk_up)) text_button_list_highlight_previous(list);
	if (keyboard_check_pressed(vk_down)) text_button_list_highlight_next(list);
}

mx = window_mouse_get_x();
my = window_mouse_get_y();

text_button_list_draw_vertical(list, _x, _y, _alignment);
