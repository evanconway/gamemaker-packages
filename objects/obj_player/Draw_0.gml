var _vel = 1.5;
if (keyboard_check(vk_up)) y -= _vel;
if (keyboard_check(vk_down)) y += _vel;
if (keyboard_check(vk_left)) x -= _vel;
if (keyboard_check(vk_right)) x += _vel;

draw_self();
draw_set_color(c_fuchsia);
//draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
draw_set_color(c_red);
draw_point(bbox_left, bbox_top);
draw_point(bbox_left, bbox_bottom - 1);
draw_point(bbox_right - 1, bbox_top);
draw_point(bbox_right - 1, bbox_bottom - 1);

if (keyboard_check_pressed(ord("F"))) window_set_fullscreen(!window_get_fullscreen());
