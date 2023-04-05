width = 320;
height = 180;

window_set_size(width * 5, height * 5);
//display_set_gui_size(width, height);

view_enabled = true;
view_visible[0] = true;

camera_set_view_size(view_camera[0], width, height);
surface_resize(application_surface, width, height);


smooth_move = new SmoothMove(x, y);
