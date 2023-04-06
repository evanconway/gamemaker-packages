width = 20;
height = 20;
surface_size_mult = 1;
var _window_multiplier = 30;

view_enabled = true;
view_visible[0] = true;

camera_set_view_size(view_camera[0], width, height);

gui_mult = 1;
//display_set_gui_size(width, height);

window_set_size(width * _window_multiplier, height * _window_multiplier);
surface_resize(application_surface, width, height);
