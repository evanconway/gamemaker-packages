var _v = 0.13;

var _idle = new StateIdle();
var _move_right = new StateInstanceMoveRightApproachObj(id, obj_state_test_wall, _v);
var _move_left = new StateInstanceMoveLeftApproachObj(id, obj_state_test_wall, _v);

state_add_connections(_idle, [_move_right, _move_left]);
state_add_connections(_move_right, [_idle, _move_left]);
state_add_connections(_move_left, [_idle, _move_right]);

state_machine = new StateMachine(_idle);
