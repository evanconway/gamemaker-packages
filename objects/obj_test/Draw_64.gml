var _x = 200;
var _y = 200;

var _on = button.is_point_on(_x, _y, window_mouse_get_x(), window_mouse_get_y());

// selected
if (button_state == 2) {
	selected_time--;
	if (selected_time <= 0) {
		button_state = _on ? 1 : 0;
		button.reset_animations_selected();
	}
// highlighted
} else if (button_state == 1) {
	if (!_on) {
		button_state = 0;
		button.reset_animations_highlighted();
	} else if (mouse_check_button_pressed(mb_left)) {
		button.reset_animations_highlighted();
		selected_time = 40;
		button_state = 2;
	}
// default
} else if (_on) {
	button.reset_animations_default();
	button_state = 1;
}

draw_text(0, 0, string(window_mouse_get_x()) + ", " + string(window_mouse_get_y()));

button.draw(_x, _y, button_state == 1, button_state == 2);
