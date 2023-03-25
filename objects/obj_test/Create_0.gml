moby = "$Call me Ishmael. Some years ago-never mind how long precisely-having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world. It is a way I have of driving off the spleen and regulating the circulation. Whenever I find myself growing grim about the mouth; whenever it is a damp, drizzly November in my soul; whenever I find myself involuntarily pausing before coffin warehouses, and bringing up the rear of every funeral I meet; and especially whenever my hypos get such an upper hand of me, that it requires a strong moral principle to prevent me from deliberately stepping into the street, and methodically knocking people's hats off-then, I account it high time to get to sea as soon as I can. This is my substitute for pistol and ball. With a philosophical flourish Cato throws himself upon his sword; I quietly take to the ship. There is nothing surprising in this. If they but knew it, almost all men in their degree, some time or other, cherish very nearly the same feelings towards the ocean with me.";
test_collapsing = "some time or other, cherish very nearly the same feelings towards the ocean with me.";

commas_and_rs = "";
for (var _i = 0; _i < 100; _i ++) commas_and_rs += "r,";
commas_and_rs += " ";
for (var _i = 0; _i < 100; _i ++) commas_and_rs += "r,";
commas_and_rs += " ";
for (var _i = 0; _i < 100; _i ++) commas_and_rs += "r,";
commas_and_rs += " ";
for (var _i = 0; _i < 100; _i ++) commas_and_rs += "r,";

test = new TypedAnimatedText(moby);
test.animated_text.text.set_default_sprite(0, spr_button);
test.animated_text.text.set_default_font(10, 40, fnt_handwriting);
test.animated_text.text.set_default_color(50, 80, c_red);
test.animated_text.text.set_default_color(100, 130, c_green);
test.animated_text.text.set_default_color(140, 170, c_blue);
test.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.FADE, 180, 210, []);
test.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.SHAKE, 220, 250, []);
test.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.TREMBLE, 260, 290, []);
test.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.CHROMATIC, 300, 330, []);
test.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.WCHROMATIC, 340, 370, []);
test.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.WAVE, 380, 410, []);
test.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.FLOAT, 420, 450, []);

for (var _i = 0; _i < 400; _i++) {
	test.add_entry_animation_at(_i, ANIMATED_TEXT_ANIMATIONS.FADEIN, []);
}

for (var _i = 400; _i < 800; _i++) {
	test.add_entry_animation_at(_i, ANIMATED_TEXT_ANIMATIONS.RISEIN, []);
}

for (var _i = 800; _i < 1000; _i++) {
	test.add_entry_animation_at(_i, ANIMATED_TEXT_ANIMATIONS.RISEIN, []);
	test.add_entry_animation_at(_i, ANIMATED_TEXT_ANIMATIONS.FADEIN, []);
}

entry_exit_state = "entry"; // "entry"
entry_exit_index = 0;

global.drawables_drawn = 0;

parse_test_text = "<blue>Hello <red>World<green>!<> Progamming is <wave:6,8>cool<>.";

//parse_text = new TagDecoratedText(parse_test_text);
