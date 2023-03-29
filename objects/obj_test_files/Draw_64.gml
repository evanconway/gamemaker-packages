
if (is_struct(data_maybe) && variable_struct_exists(data_maybe, "message")) {
	draw_text(100, 100, variable_struct_get(data_maybe, "message"))
} else {
	draw_text(100, 100, "could not load data");
}
