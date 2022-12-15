if (keyboard_check_pressed(ord("R"))) game_restart();

global.drawables_drawn = 0;

test.draw(40, 80);

draw_set_color(c_lime);
draw_set_alpha(1);
draw_text(0, 0, fps_real);
draw_text(0, 20, "drawables: " + string(global.drawables_drawn));
