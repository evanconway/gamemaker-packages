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

if (keyboard_check(vk_space)) {
	test.set_color(600, 900, c_yellow);
}

test.draw(40, 40);

draw_set_color(c_lime);
draw_text(0, 0, fps_real);
