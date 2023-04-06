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
 * @param {real} _y Y position of this box.
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

function box_get_by_name(_box_name) {
	if (!ds_map_exists(global.boxes_map, _box_name)) show_error("unknown box name referenced", true);
	return ds_map_find_value(global.boxes_map, _box_name);
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

function box_draw(_name, _color = c_fuchsia) {
	var _box_arr = box_get_by_name(_name);
	draw_set_color(_color);
	draw_set_alpha(1);
	for (var _i = 0; _i < array_length(_box_arr); _i++) {
		var _x = _box_arr[_i].position_x;
		var _y = _box_arr[_i].position_y;
		var _width = _box_arr[_i].width - 1;
		var _height = _box_arr[_i].height - 1;
		
		/*
		We draw rectangles 1 pixel in width to draw the boxes, this ensures
		that boxes look correct in the draw or gui layer. GameMaker does
		not normally respect line thickness in regards to resolution in the
		gui layer.
		*/
		// left vertical
		draw_rectangle(_x, _y, _x, _y + _height, false);
		// right vertical
		draw_rectangle(_x + _width, _y, _x + _width, _y + _height, false);
		// top horizontal
		draw_rectangle(_x + 1, _y, _x + _width - 1, _y, false);
		// bottom horizontal
		draw_rectangle(_x + 1, _y + _height, _x + _width - 1, _y + _height, false);
	}
}

function box_clear_all() {
	ds_map_clear(global.boxes_map);
	ds_map_clear(global.boxes_group_name_map);
}
