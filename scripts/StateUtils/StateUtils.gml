/**
 * With this function you can check a position for a collision with all instances of an object
 * using the collision mask of the instance that runs the code for the check. Returns an array
 * of all instances of given object that collide. Array is ordered from closest instance
 * to furthest.
 *
 * @param {real} _x
 * @param {real} _y
 * @param {Asset.GMObject} _obj
 */
function instance_place_array_perfect(_x, _y, _obj) {
	var _offset_x = _x - x;
	var _offset_y = _y - y;
	
	var _bbox_left = bbox_left + _offset_x;
	var _bbox_right = bbox_right + _offset_x;
	var _bbox_top = bbox_top + _offset_y;
	var _bbox_bottom = bbox_bottom + _offset_y;
	
	var _result = [];
	
	for (var _i = 0; _i < instance_number(_obj); _i++) {
		var _instance_checking = instance_find(_obj, _i);
		if (_bbox_left < _instance_checking.bbox_right &&
			_bbox_right >_instance_checking.bbox_left &&
			_bbox_top < _instance_checking.bbox_bottom &&
			_bbox_bottom > _instance_checking.bbox_top
		) {
			show_debug_message("collision");
			array_push(_result, {
				inst_id: _instance_checking.id,
				dist: point_distance(_x, _y, _instance_checking.x, _instance_checking.y)
			});
		}
	}
	
	array_sort(_result, function(_a, _b) {
		return _a.dist - _b.dist;
	});
	return array_map(_result, function(_e) {
		return _e.inst_id;
	});
}

/**
 * @param {Id.Instance} _id
 * @param {Asset.GMObject} _obj_approaching
 * @param {real} _vx
 */
function obj_get_x_approach_obj(_id, _obj_approaching, _vx) {
	if (_vx == 0) return 0;
	with (_id) {
		var _x_moved = 0;
		var _adjust = 0;
		while (abs(_x_moved) < abs(_vx)) {
			_adjust = min(1, abs(_vx) - abs(_x_moved)) * sign(_vx);
			var _instances_colliding = instance_place_array_perfect(x + _x_moved + _adjust, y, _obj_approaching);
			if (array_length(_instances_colliding) > 0) {
				var _obj_snap_to = _instances_colliding[0];
				var _bbox_left = real(_obj_snap_to.bbox_left);
				var _bbox_right = real(_obj_snap_to.bbox_right);
				return _vx > 0 ? _bbox_left - bbox_right : _bbox_right - bbox_left;
			} else _x_moved += _adjust;
		}
		return _x_moved;
	}
}

/**
 * @param {Id.Instance} _id
 * @param {Asset.GMObject} _obj_approaching
 * @param {real, undefined} _vy
 */
function obj_get_y_approach_obj(_id, _obj_approaching, _vy) {
	if (_vy == 0) return 0;
	with (_id) {
		var _y_moved = 0;
		var _adjust = 0;
		while (abs(_y_moved) < abs(_vy)) {
			_adjust = min(1, abs(_vy) - abs(_y_moved)) * sign(_vy);
			if (!place_meeting(x, y + _y_moved + _adjust, _obj_approaching)) _y_moved += _adjust;
			else return _y_moved;
		}
		return _y_moved;
	}
}

/**
 * Move given object instance to given xy position, but if collision with given 
 * obj_against an error is thrown.
 *
 * @param {Id.Instance} _id
 * @param {Asset.GMObject} _obj_against
 * @param {real} _x
 * @param {real} _y
 */
function obj_move_to_xy_against_obj(_id, _obj_against, _x, _y) {
	with (_id) {
		x = _x;
		y = _y;
		if (place_meeting(x, y, _obj_against)) {
			show_error(object_get_name(object_index) + " could not be moved to (" + string(_x) + "," + string(_y) + " due to collision with " + object_get_name(_obj_against), true);
		}
	}
}