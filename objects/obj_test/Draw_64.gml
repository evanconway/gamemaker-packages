test.draw(40, 40);

draw_set_color(c_lime);
draw_text(0, 0, fps_real);

if (keyboard_check_pressed(vk_space)) test.switch_draw_function();
