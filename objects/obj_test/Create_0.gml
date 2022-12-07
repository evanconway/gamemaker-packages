test = new StyleableText("Call me Ishmael. Some years ago-never mind how long precisely-having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world. It is a way I have of driving off the spleen and regulating the circulation. Whenever I find myself growing grim about the mouth; whenever it is a damp, drizzly November in my soul; whenever I find myself involuntarily pausing before coffin warehouses, and bringing up the rear of every funeral I meet; and especially whenever my hypos get such an upper hand of me, that it requires a strong moral principle to prevent me from deliberately stepping into the street, and methodically knocking people's hats off-then, I account it high time to get to sea as soon as I can. This is my substitute for pistol and ball. With a philosophical flourish Cato throws himself upon his sword; I quietly take to the ship. There is nothing surprising in this. If they but knew it, almost all men in their degree, some time or other, cherish very nearly the same feelings towards the ocean with me.");

test.split_drawables_at( 30, 40);

test.set_default_scale_x(0, 10, 2);
test.set_default_scale_y(20, 30, 2);
test.set_default_font(40, 55, fnt_handwriting);
test.set_default_sprite(60, spr_button);
test.set_default_color(70, 80, c_fuchsia);
test.set_default_alpha(90, 100, 0.4);
test.set_default_mod_x(110, 120, -5);
test.set_default_mod_y(130, 140, 5);
test.set_default_mod_angle(150, 160, 30);
