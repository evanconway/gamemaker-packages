var _vel = 1;
if (keyboard_check_pressed(vk_right)) box_x += _vel;
if (keyboard_check_pressed(vk_left)) box_x -= _vel;
if (keyboard_check_pressed(vk_down)) box_y += _vel;
if (keyboard_check_pressed(vk_up)) box_y -= _vel;

box_place(8, 8, 4, 4, "wall");
box_draw("wall", c_lime);
box_place(box_x, box_y, 4, 4, "player");
box_draw("player");
if (boxes_get_name_collides_name("player", "wall")) {
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_text(0, 0, "!");
}
box_clear_all();
