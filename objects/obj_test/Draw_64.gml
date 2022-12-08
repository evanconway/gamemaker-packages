/*
if (entry_exit_state == "entry") {
	if (entry_exit_index < test.get_character_count()) {
		test.add_animation(ANIMATED_TEXT_ANIMATIONS.FADEIN, entry_exit_index, entry_exit_index, []);
		entry_exit_index++;
	} else {
		entry_exit_state = "wait";
		entry_exit_index = 0;
	}
}
*/

if (keyboard_check_pressed(ord("1"))) {
	test.add_animation(ANIMATED_TEXT_ANIMATIONS.FADEIN, 0, 0, []);
}

if (keyboard_check_pressed(ord("2"))) {
	test.add_animation(ANIMATED_TEXT_ANIMATIONS.FADEIN, 1, 1, []);
}

if (keyboard_check_pressed(ord("R"))) game_restart();

global.drawables_drawn = 0;

test.draw(40, 80);

draw_set_color(c_lime);
draw_set_alpha(1);
draw_text(0, 0, fps_real);
draw_text(0, 20, "drawables: " + string(global.drawables_drawn));
