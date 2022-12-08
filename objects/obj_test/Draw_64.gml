/*
	set_sprite
	set_scale_x
	set_scale_y
	set_font
	set_color
	set_alpha
	set_mod_x
	set_mod_y
	set_mod_angle
*/

// 0-81 are line index 0
if (keyboard_check(vk_space)) {
	test.set_color(10, 19, c_red);
	test.set_color(20, 29, c_green);
	test.set_color(30, 49, c_blue);
}
// merge everything
if (keyboard_check(ord("1"))) {
	test.merge_drawables_at(0, 1106);
}

// merge starting and ending middle of drawables
if (keyboard_check(ord("2"))) {
	test.merge_drawables_at(15, 35);
}

// merge start at edge end in middle
if (keyboard_check(ord("3"))) {
	test.merge_drawables_at(0, 35);
}

// marge start in middle end at edge
if (keyboard_check(ord("4"))) {
	test.merge_drawables_at(15, 81);
}

global.drawables_drawn = 0;

test.draw(40, 40);

draw_set_color(c_lime);
draw_text(0, 0, fps_real);
draw_text(0, 20, "drawables: " + string(global.drawables_drawn));
