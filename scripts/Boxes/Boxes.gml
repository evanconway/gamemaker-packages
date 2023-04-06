/*
Two maps for managing boxes. The boxes_map is a mapping of box names to arrays of box objects with that name.
The boxes_name_group_map is a mapping of box group names to box names. This helps us do two things. First it
helps us ensure that all boxes with the same name are assigned to the same group. Secondly it helps us
get all boxes of the same group.
*/
global.boxes_map = ds_map_create();
global.boxes_group_name_map = ds_map_create();

/**
 * @param {real} _x X position of this box.
 * @param {real} _y Y position of this box..
 * @param {real} _width Box width.
 * @param {real} _height Box height.
 * @param {string, real} _name Name of the box. Boxes with the same name are collision checked together.
 * @param {string, real} _group Group of the box. Boxes with same group can be collision checked together.
 */
function Box(_x, _y, _width, _height, _name, _group) constructor {
	position_x = _x;
	position_y = _y;
	
	if (_width < 1 || _height < 1) show_error("box width and height must be greater than or equal to 1", true);
	
	width = floor(_width);
	height = floor(_height);
	name = _name;
	group = _group;
}

function box_place(_x, _y, _width, _height, _name = "box", _group = "default") {
	if (!ds_map_exists(global.boxes_map, _name)) {
		ds_map_set(global.boxes_map, _name, []);
		ds_map_set(global.boxes_group_name_map, _group, [_name]);
	}
	var _box_arr = ds_map_find_value(global.boxes_map, _name);
	array_push(_box_arr, new Box(_x, _y, _width, _height, _name, _group));
	var _name_arr = ds_map_find_value(global.boxes_group_name_map, _group);
	if (!array_contains(_name_arr, _name)) array_push(_name_arr, _name);
}

function box_draw(_name, _x, _y, _color = c_fuchsia) {
	if (!ds_map_exists(global.boxes_map, _name)) show_error("unknown box name cannot be drawn", true);
	var _box_arr = ds_map_find_value(global.boxes_map, _name);
	draw_set_color(_color)
	draw_set_alpha(1);
	for (var _i = 0; _i < array_length(_box_arr); _i++) {
		var _box = _box_arr[_i];
		draw_rectangle(_x, _y, _x + _box.width - 1, _y + _box.height - 1, true);
	}
}

function box_clear_all() {

}
