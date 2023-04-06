function camera_init_basic(_width, _height) {
	view_enabled = true;
	view_visible[0] = true;
	window_set_size(_width, _height);
	camera_set_view_size(view_camera[0], _width, _height);
	surface_resize(application_surface, _width, _height);
}
