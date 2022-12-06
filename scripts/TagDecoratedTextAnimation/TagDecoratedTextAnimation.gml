global.tds_animation_default_fade_alpha_min = 0.3;
global.tds_animation_default_fade_alpha_max = 1;
global.tds_animation_default_fade_cycle_time_ms = 1000;

/**
 * @desc Set default values for fade animation.
 * @param {real} _alpha_min minimum alpha
 * @param {real} _alpha_max maximum alpha
 * @param {real} _cycle_time_ms time in ms for one cycle of animation
 */
function tag_decorated_text_set_default_fade(_alpha_min, _alpha_max, _cycle_time_ms) {
	global.tds_animation_default_fade_alpha_min = _alpha_min;
	global.tds_animation_default_fade_alpha_max = _alpha_max;
	global.tds_animation_default_fade_cycle_time_ms = _cycle_time_ms;
}

global.tds_animation_default_shake_time_ms = 80;
global.tds_animation_default_shake_magnitude = 1;

/**
 * Set default values for shake animation.
 * @param {real} _time_ms time in ms text is held out of place
 * @param {real} _magnitude magnitude in pixels text can be offset by
 */
function tds_animation_default_shake(_time_ms, _magnitude) {
	global.tds_animation_default_shake_time_ms = _time_ms;
	global.tds_animation_default_shake_magnitude = _magnitude;
}

global.tds_animation_default_tremble_time_ms = 80;
global.tds_animation_default_tremble_magnitude = 2;

/**
 * Set default values for tremble animation.
 * @param {real} _time_ms time in ms text is held out of place
 * @param {real} _magnitude magnitude in pixels text can be offset by
 */
function tds_animation_default_tremble(_time_ms, _magnitude) {
	global.tds_animation_default_tremble_time_ms = _time_ms;
	global.tds_animation_default_tremble_magnitude = _magnitude;
}

global.tds_animation_default_chromatic_change_ms = 32;
global.tds_animation_default_chromatic_steps_per_change = 10;
global.tds_animation_default_chromatic_char_offset = -30;

/**
 * Set default values for chromatic animation.
 * @param {real} _change_ms time in ms between color changes
 * @param {real} _steps_per_change the integer steps in the rgb value per change
 * @param {real} _char_offset the difference in color between each character
 */
function tds_animation_default_chromatic(_change_ms, _steps_per_change, _char_offset) {
	global.tds_animation_default_chromatic_change_ms = _change_ms;
	global.tds_animation_default_chromatic_steps_per_change = _steps_per_change;
	global.tds_animation_default_chromatic_char_offset = _char_offset;
}

global.tds_animation_default_wchromatic_change_ms = 32;
global.tds_animation_default_wchromatic_steps_per_change = 10;

/**
 * Set default values for wchromatic (word chromatic) animation.
 * @param {real} _change_ms time in ms between color changes
 * @param {real} _steps_per_change the integer steps in the rgb value per change
 */
function tds_animation_default_wchromatic(_change_ms, _steps_per_change) {
	global.tds_animation_default_wchromatic_change_ms = _change_ms;
	global.tds_animation_default_wchromatic_steps_per_change = _steps_per_change;
}

global.tds_animation_default_wave_cycle_time_ms = 1000;
global.tds_animation_default_wave_magnitude = 3;
global.tds_animation_default_wave_char_offset = 0.5;

/**
 * Set default values for wave animation.
 * @param {real} _cycle_time_ms time in ms per cycle
 * @param {real} _magnitude the magnitude of vertical motion the text will have
 * @param {real} _char_offset the difference in motion between each character
 */
function tds_animation_default_wave(_cycle_time_ms, _magnitude, _char_offset) {
	global.tds_animation_default_wave_cycle_time = _cycle_time_ms;
	global.tds_animation_default_wave_magnitude = _magnitude;
	global.tds_animation_default_wave_char_offset = _char_offset;
}

global.tds_animation_default_float_cycle_time_ms = 1000;
global.tds_animation_default_float_magnitude = 3;

/**
 * Set default values for the float animation.
 * @param {real} _cycle_time_ms time in ms per cycle
 * @param {real} _magnitude the magnitude of vertical motion the text will have
 */
function tds_animation_default_float(_cycle_time_ms, _magnitude) {
	global.tds_animation_default_float_cycle_time = _cycle_time_ms;
	global.tds_animation_default_float_magnitude = _magnitude;
}

global.tds_animation_default_wobble_cycle_time_ms = 1000;
global.tds_animation_default_wobble_max_angle = 10;

/**
 * Set default values for the wobble animation.
 * @param {real} _cycle_time_ms time in ms per cycle
 * @param {real} _max_angle maximum angle the wobble will reach in degree
 */
function tds_animation_default_wobble(_cycle_time_ms, _max_angle) {
	global.tds_animation_default_wobble_cycle_time_ms = _cycle_time_ms;
	global.tds_animation_default_wobble_max_angle = _max_angle;
}

/**
 * @param {real} _command TAG_DECORATED_TEXT_COMMAND enum entry
 * @param {array<any>} _aargs argument array for command
 * @param {real} _char_index index of character the animation refers to in character array
 */
function TagDecoratedTextAnimation(_command, _aargs, _char_index) constructor {
	style = new TagDecoratedTextStyle();
	style.set_undefined();
	command = _command;
	params = _aargs;
	character_index = _char_index;
	mergeable = true;
	content_width = 0;
	content_height = 0;
	
	/// @param {real} _time_ms
	update = function(_time_ms) {};
	
	/**
	 * Get a copy of this animation instance.
	 */
	copy = function() {
		var _result = new TagDecoratedTextAnimation(command, params, character_index);
		_result.style = style.copy();
		_result.mergeable = mergeable;
		_result.content_width = content_width;
		_result.content_height = content_height;
		return _result;
	};
	
	/**
	 * Get this animations command and params as a string. Useful for comparing against other animations.
	 */
	get_hash = function() {
		/// @param {string} _prev
		/// @param {any} _param
		var _reduce = function(_prev, _param) {
			return _prev + string(_param);
		};
		return string(command) + string(array_reduce(params, _reduce, ""));
	}
	
	// mark object as valid animation if command is animation command
	valid_animation_command = false;
	
	if (command == TAG_DECORATED_TEXT_COMMANDS.FADE) {
		alpha_min = global.tds_animation_default_fade_alpha_min;
		alpha_max = global.tds_animation_default_fade_alpha_max;
		cycle_time = global.tds_animation_default_fade_cycle_time_ms;
		if (array_length(params) == 3) {
			alpha_min = params[0];
			alpha_max = params[1];
			cycle_time = params[2];
		} else if (array_length(params) != 0) {
			show_error("TDT Error: Improper number of args for fade animation!", true);
		}
		
		style.alpha = 1;
		
		/// @param {real} _time_ms
		update = function(_time_ms) {
			var _check = _time_ms % (cycle_time * 2);
			if (_check <= cycle_time) {
				_check = cycle_time - _check;
			} else {
				_check -= cycle_time;
			}
			var _new_alpha = alpha_min + _check/cycle_time * (alpha_max - alpha_min);
			style.alpha = _new_alpha;
		};
		valid_animation_command = true;
	}
	
	// we could totally combine the shake and tremble animation here, do later
	if (command == TAG_DECORATED_TEXT_COMMANDS.SHAKE) {
		mergeable = false;
		shake_time = global.tds_animation_default_shake_time_ms;
		shake_magnitude = global.tds_animation_default_shake_magnitude;
		if (array_length(params) == 2) {
			shake_time = params[0];
			shake_magnitude = params[1];
		} else if (array_length(params) != 0) {
			show_error("TDT Error: Improper number of args for shake animation!", true);
		}
		
		style.mod_x = 0;
		style.mod_y = 0;
		
		/// @param {real} _time_ms
		update = function(_time_ms) {
			var _index_x = floor(_time_ms / shake_time) + character_index * 1000;
			var _index_y= _index_x + 4321; // arbitrary character index offset
			style.mod_x = floor(shake_magnitude * 2 * tag_decorated_text_get_random(_index_x)) - shake_magnitude;
			style.mod_y = floor(shake_magnitude * 2 * tag_decorated_text_get_random(_index_y)) - shake_magnitude;
		};
		
		valid_animation_command = true;
	}
	
	if (command == TAG_DECORATED_TEXT_COMMANDS.TREMBLE) {
		shake_time = global.tds_animation_default_tremble_time_ms;
		shake_magnitude = global.tds_animation_default_tremble_magnitude;
		if (array_length(params) == 2) {
			shake_time = params[0];
			shake_magnitude = params[1];
		} else if (array_length(params) != 0) {
			show_error("TDT Error: Improper number of args for tremble animation!", true);
		}
		
		style.mod_x = 0;
		style.mod_y = 0;
		
		/// @param {real} _time_ms
		update = function(_time_ms) {
			var _index_x = floor(_time_ms / shake_time);
			var _index_y = _index_x + 4321; // arbitrary character index offset
			style.mod_x = floor(shake_magnitude * 2 * tag_decorated_text_get_random(_index_x)) - shake_magnitude;
			style.mod_y = floor(shake_magnitude * 2 * tag_decorated_text_get_random(_index_y)) - shake_magnitude;
		};
		
		valid_animation_command = true;
	}
	
	if (command == TAG_DECORATED_TEXT_COMMANDS.CHROMATIC) {
		mergeable = false;
		change_ms = global.tds_animation_default_chromatic_change_ms;
		steps_per_change = global.tds_animation_default_chromatic_steps_per_change;
		char_offset = global.tds_animation_default_chromatic_char_offset;
		if (array_length(params) == 3) {
			change_ms = params[0];
			steps_per_change = params[1];
			char_offset = params[2];
		} else if (array_length(params) != 0) {
			show_error("TDT Error: Improper number of args for chromatic animation!", true);
		}
		
		style.style_color = c_white;
		
		/// @param {real} _time_ms
		update = function(_time_ms) {
			var _index = floor(_time_ms/change_ms) * steps_per_change;
			_index += char_offset * character_index;
			style.style_color = tag_decorated_text_get_chromatic_color_at(_index);
		};
		
		valid_animation_command = true;
	}
	
	if (command == TAG_DECORATED_TEXT_COMMANDS.WCHROMATIC) {
		change_ms = global.tds_animation_default_wchromatic_change_ms;
		steps_per_change = global.tds_animation_default_wchromatic_steps_per_change;
		if (array_length(params) == 2) {
			change_ms = params[0];
			steps_per_change = params[1];
		} else if (array_length(params) != 0) {
			show_error("TDT Error: Improper number of args for wchromatic animation!", true);
		}
		
		style.style_color = c_white;
		
		/// @param {real} _time_ms
		update = function(_time_ms) {
			var _index = floor(_time_ms/change_ms) * steps_per_change;
			style.style_color = tag_decorated_text_get_chromatic_color_at(_index);
		};
		
		valid_animation_command = true;
	}
	
	if (command == TAG_DECORATED_TEXT_COMMANDS.WAVE) {
		mergeable = false;
		cycle_time = global.tds_animation_default_wave_cycle_time_ms;
		magnitude = global.tds_animation_default_wave_magnitude;
		char_offset = global.tds_animation_default_wave_char_offset;
		if (array_length(params) == 3) {
			change_ms = params[0];
			magnitude = params[1];
			char_offset = params[2];
		} else if (array_length(params) != 0) {
			show_error("TDT Error: Improper number of args for wave animation!", true);
		}
		
		style.mod_y = 0;
		
		/// @param {real} _time_ms
		update = function(_time_ms) {
			_time_ms %= cycle_time;
			var _percent = _time_ms / cycle_time;
			style.mod_y = sin(_percent * -2 * pi + char_offset * character_index) * magnitude;
		};
		
		valid_animation_command = true;
	}
	
	if (command == TAG_DECORATED_TEXT_COMMANDS.FLOAT) {
		cycle_time = global.tds_animation_default_float_cycle_time_ms;
		magnitude = global.tds_animation_default_float_magnitude;
		if (array_length(params) == 2) {
			change_ms = params[0];
			magnitude = params[1];
		} else if (array_length(params) != 0) {
			show_error("TDS Error: Improper number of args for float animation!", true);
		}
		
		style.mod_y = 0;
		
		/// @param {real} _time_ms
		update = function(_time_ms) {
			_time_ms %= cycle_time;
			var _percent = _time_ms / cycle_time;
			style.mod_y = sin(_percent * 2 * pi + 0.5 * pi) * magnitude;
		};
		
		valid_animation_command = true;
	}
	
	if (command == TAG_DECORATED_TEXT_COMMANDS.WOBBLE) {
		cycle_time = global.tds_animation_default_wobble_cycle_time_ms;
		max_angle = global.tds_animation_default_wobble_max_angle;
		if (array_length(params) == 2) {
			cycle_time = params[0];
			max_angle = params[1];
		} else if (array_length(params) != 0) {
			show_error("TDT Error: Improper number of args for wobble animation!", true);
		}
		
		style.mod_x = 0;
		style.mod_y = 0;
		style.mod_angle = 0;
		
		/// @param {real} _time_ms
		update = function(_time_ms) {
			_time_ms %= cycle_time;
			var _percent = _time_ms / cycle_time;
			style.mod_angle = sin(_percent * 2 * pi + -0.5) * max_angle;
			var _vec_x = content_width / -2;
			var _vec_y = content_height / -2;
			var _hypotenuse = point_distance(0, 0, _vec_x, _vec_y);
			var _theta = point_direction(0, 0, _vec_x, _vec_y);
			_theta += style.mod_angle;
			style.mod_x = lengthdir_x(_hypotenuse, _theta) - _vec_x;
			style.mod_y = lengthdir_y(_hypotenuse, _theta) - _vec_y;
			if (style.mod_angle != 0 && os_browser == browser_not_a_browser) {
				style.mod_y -= 2; // magic angle correct number, native only
			}
		};
		
		valid_animation_command = true;
	}
}

/**
 * Get an empty array that feather will recognize as type TagDecoratedTextAnimation.
 * @return {array<struct.TagDecoratedTextAnimation>} an empty array of type TagDecoratedTextAnimations
 */
function tag_decorated_text_get_empty_array_animations() {
	return array_create(0, new TagDecoratedTextAnimation(TAG_DECORATED_TEXT_COMMANDS.FADE, [], 0));
}
