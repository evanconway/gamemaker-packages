global.tag_decorated_text_default_font = fnt_menu;
list = new TextButtonList(["new game", "load game", "options", "exit"], "gray", "yellow fade", "lime tremble");
mx = window_mouse_get_x();
my = window_mouse_get_y();
selected_time = -1;

//text_button_list_set_animation_reset_options(list, false, false, false);
