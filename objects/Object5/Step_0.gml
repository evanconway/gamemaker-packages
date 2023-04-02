var _clicked = [];
var _count = 10
for (var _i = 0; _i < _count; _i++) {
	var _mb = mouse_check_button_pressed(mb_left);
	if (_mb) array_push(_clicked, _mb);
}

if (array_length(_clicked) > 0) {
	show_debug_message("mouse clicked registered " + string(array_length(_clicked)) + " out of " + string(_count));
}
