if (keyboard_check_pressed(vk_space)) test.advance();
if (keyboard_check_pressed(ord("U"))) updating = !updating;

if (updating) test.update();
else test.update(0);
test.draw(40, 40);
tag_decorated_text_draw_performance(0, 0);
