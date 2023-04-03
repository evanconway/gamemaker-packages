function StateIdle(): State() constructor {
	can_end = function() {
		return true;
	}
	
	can_start = function() {
		return true;
	}
}

/**
 * State that, when active, moves given instance to the left. Collides with given object to approach.
 *
 * @param {Id.Instance} _instance_id
 * @param {Asset.GMObject} _obj_approaching
 * @param {real} _velocity
 */
function StateInstanceMoveRightApproachObj(_instance_id, _obj_approaching, _velocity): State() constructor {
	instance_ref = _instance_id;
	object_approaching_ref = _obj_approaching;
	
	velocity = abs(_velocity);
	
	get_input = function() {
		return keyboard_check(vk_right);
	};
	
	can_end = function() {
		var _against_wall = false;
		with (instance_ref) {
			_against_wall = place_meeting(x + sign(other.velocity), y, other.object_approaching_ref);
		}
		return !get_input() || _against_wall;
	};
	
	can_start = function() {
		var _against_wall = false;
		with (instance_ref) {
			_against_wall = place_meeting(x + sign(other.velocity), y, other.object_approaching_ref);
		}
		return get_input() && !_against_wall;
	};
	
	update = function() {
		var _move_x = obj_get_x_approach_obj(instance_ref, object_approaching_ref, velocity);
		obj_move_to_xy_against_obj(instance_ref, object_approaching_ref, instance_ref.x + _move_x, instance_ref.y);
	};
}

/**
 * State that, when active, moves given instance to the left. Collides with given object to approach.
 *
 * @param {Id.Instance} _instance_id
 * @param {Asset.GMObject} _obj_approaching
 * @param {real} _velocity
 */
function StateInstanceMoveLeftApproachObj(_instance_id, _obj_approaching, _velocity): StateInstanceMoveRightApproachObj(_instance_id, _obj_approaching, _velocity) constructor {
	velocity = abs(_velocity) * -1;
	
	get_input = function() {
		return keyboard_check(vk_left);
	};
}


/**
 * State that, when active, moves given instance to the left. Collides with given object to approach. Also
 * checks that instance is on top of given object to approach, simulating the ground.
 *
 * @param {Id.Instance} _instance_id
 * @param {Asset.GMObject} _obj_approaching
 * @param {real} _velocity
 */
function StateInstanceMoveRightApproachObjGrounded(_instance_id, _obj_approaching, _velocity): StateInstanceMoveRightApproachObj(_instance_id, _obj_approaching, _velocity) constructor {
	can_end = function() {
		var _against_wall = false;
		var _on_ground = false;
		with (_instance_id) {
			_against_wall = place_meeting(x + sign(other.velocity), y, other.object_approaching_ref);
			_on_ground = place_meeting(x, y + 1, other.object_approaching_ref);
		}
		return !get_input() || _against_wall;
	};
	
	can_start = function() {
		var _against_wall = false;
		var _on_ground = false;
		with (_instance_id) {
			_against_wall = place_meeting(x + sign(other.velocity), y, other.object_approaching_ref);
			_on_ground = place_meeting(x, y + 1, other.object_approaching_ref);
		}
		return get_input() && !_against_wall;
	};
}

/**
 * State that, when active, moves given instance to the right. Collides with given object to approach. Also
 * checks that instance is on top of given object to approach, simulating the ground.
 *
 * @param {Id.Instance} _instance_id
 * @param {Asset.GMObject} _obj_approaching
 * @param {real} _velocity
 */
function StateInstanceMoveLeftApproachObjGrounded(_instance_id, _obj_approaching, _velocity): StateInstanceMoveRightApproachObjGrounded(_instance_id, _obj_approaching, _velocity) constructor {
	velocity = abs(_velocity) * -1;
	
	get_input = function() {
		return keyboard_check(vk_left);
	};
}

/**
 * @param {Asset.GMObject} _obj
 */
function StateTestJump(_obj) : State()  constructor {
	vertical_velocity = 0
	
	can_end = function() {
		var _not_in_wall = !place_meeting(x, y, obj_state_test_wall);
		var _on_top_of_wall = place_meeting(x, y + 1, obj_state_test_wall);
		return _not_in_wall && _on_top_of_wall;
	};
	
	can_start = function() {
		var _not_in_wall = !place_meeting(x, y, obj_state_test_wall);
		var _on_top_of_wall = place_meeting(x, y + 1, obj_state_test_wall);
		return _not_in_wall && _on_top_of_wall && keyboard_check_pressed(vk_space);
	}
	
	/// @param {real} _update_time_ms
	update = function(_update_time_ms) {
		vertical_velocity = clamp(vertical_velocity + 0.3, -10, 10);
		var _v = vertical_velocity;
		while (!place_meeting(x, y + sign(_v), obj_state_test_wall) && _v != 0) {
			y += sign(_v);
			
			if (_v > 0) {
				_v--;
				_v = _v <= 0 ? 0 : _v;
			} else {
				_v++;
				_v = _v >= 0 ? 0 : _v;
			}
		}
	};
}
