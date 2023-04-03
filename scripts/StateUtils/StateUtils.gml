/**
 * @param {Id.Instance} _id
 * @param {Asset.GMObject} _obj_approaching
 * @param {real} _vx
 */
function obj_get_x_approach_obj(_id, _obj_approaching, _vx) {
	with (_id) {
		var _x_moved = 0;
		var _adjust = 0;
		while (abs(_x_moved) < abs(_vx)) {
			_adjust = min(1, abs(_vx) - abs(_x_moved)) * sign(_vx);
			if (!place_meeting(x + _x_moved +_adjust, y, _obj_approaching)) _x_moved += _adjust;
			else return _x_moved;
		}
		return _x_moved;
	}
}

/**
 * @param {Id.Instance} _id
 * @param {Asset.GMObject} _obj_approaching
 * @param {real} _vy
 */
function obj_get_y_approach_obj(_id, _obj_approaching, _vy) {
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