if (keyboard_check_pressed(vk_left)) {
	if (alignment == fa_right) alignment = fa_center;
	else if (alignment == fa_center) alignment = fa_left;
}

if (keyboard_check_pressed(vk_right)) {
	if (alignment == fa_left) alignment = fa_center;
	else if (alignment == fa_center) alignment = fa_right;
}

test.draw(40, 40, alignment);
tag_decorated_text_draw_performance(0, 0);
