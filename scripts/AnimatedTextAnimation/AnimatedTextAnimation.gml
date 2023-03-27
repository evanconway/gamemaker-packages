enum ANIMATED_TEXT_ANIMATIONS {
	FADEIN,
	RISEIN,
	FADE,
	SHAKE,
	TREMBLE,
	CHROMATIC,
	WCHROMATIC,
	WAVE,
	FLOAT
}

// DEFAULTs

global.animated_text_default_fadein_duration = 200;

/**
 * Set default values for fadein animation
 * @param {real} _duration duration of fadein animation
 */
function animated_text_set_default_fadein(_duration) {
	global.animated_text_default_fadein_duration = _duration;
}

animated_text_set_default_fadein(200);


global.animated_text_default_risein_duration = 200;

/**
 * Set default values for risein animation
 * @param {real} _duration duration of risein animation
 */
function animated_text_set_default_risein(_duration) {
	global.animated_text_default_risein_duration = _duration;
}

animated_text_set_default_risein(200);


global.animated_text_default_fade_alpha_min = 0.3;
global.animated_text_default_fade_alpha_max = 1;
global.animated_text_default_fade_cycle_time_ms = 1000;

/**
 * Set default values for fade animation.
 * @param {real} _alpha_min minimum alpha
 * @param {real} _alpha_max maximum alpha
 * @param {real} _cycle_time_ms time in ms for one cycle of animation
 */
function animated_text_set_default_fade(_alpha_min, _alpha_max, _cycle_time_ms) {
	global.animated_text_default_fade_alpha_min = _alpha_min;
	global.animated_text_default_fade_alpha_max = _alpha_max;
	global.animated_text_default_fade_cycle_time_ms = _cycle_time_ms;
}

animated_text_set_default_fade(0.3, 1, 1000);


global.animated_text_default_shake_time_ms = 60;
global.animated_text_default_shake_magnitude = 1;

/**
 * Set default values for shake animation.
 * @param {real} _time_ms time in ms text is held out of place
 * @param {real} _magnitude magnitude in pixels text can be offset by
 */
function animated_text_default_shake(_time_ms, _magnitude) {
	global.animated_text_default_shake_time_ms = _time_ms;
	global.animated_text_default_shake_magnitude = _magnitude;
}

animated_text_default_shake(60, 1);


global.animated_text_default_tremble_time_ms = 80;
global.animated_text_default_tremble_magnitude = 1;

/**
 * Set default values for tremble animation.
 * @param {real} _time_ms time in ms text is held out of place
 * @param {real} _magnitude magnitude in pixels text can be offset by
 */
function animated_text_default_tremble(_time_ms, _magnitude) {
	global.animated_text_default_tremble_time_ms = _time_ms;
	global.animated_text_default_tremble_magnitude = _magnitude;
}

animated_text_default_tremble(80, 1);


global.animated_text_default_chromatic_change_ms = 32;
global.animated_text_default_chromatic_steps_per_change = 10;
global.animated_text_default_chromatic_char_offset = -30;

/**
 * Set default values for chromatic animation.
 * @param {real} _change_ms time in ms between color changes
 * @param {real} _steps_per_change the integer steps in the rgb value per change
 * @param {real} _char_offset the difference in color between each character
 */
function animated_text_default_chromatic(_change_ms, _steps_per_change, _char_offset) {
	global.animated_text_default_chromatic_change_ms = _change_ms;
	global.animated_text_default_chromatic_steps_per_change = _steps_per_change;
	global.animated_text_default_chromatic_char_offset = _char_offset;
}

animated_text_default_chromatic(32, 10, 30);


global.animated_text_default_wchromatic_change_ms = 32;
global.animated_text_default_wchromatic_steps_per_change = 10;

/**
 * Set default values for wchromatic (word chromatic) animation.
 * @param {real} _change_ms time in ms between color changes
 * @param {real} _steps_per_change the integer steps in the rgb value per change
 */
function animated_text_default_wchromatic(_change_ms, _steps_per_change) {
	global.animated_text_default_wchromatic_change_ms = _change_ms;
	global.animated_text_default_wchromatic_steps_per_change = _steps_per_change;
}

animated_text_default_wchromatic(32, 10);


global.animated_text_default_wave_cycle_time_ms = 1000;
global.animated_text_default_wave_magnitude = 3;
global.animated_text_default_wave_char_offset = 0.5;

/**
 * Set default values for wave animation.
 * @param {real} _cycle_time_ms time in ms per cycle
 * @param {real} _magnitude the magnitude of vertical motion the text will have
 * @param {real} _char_offset the difference in motion between each character
 */
function animated_text_default_wave(_cycle_time_ms, _magnitude, _char_offset) {
	global.animated_text_default_wave_cycle_time_ms = _cycle_time_ms;
	global.animated_text_default_wave_magnitude = _magnitude;
	global.animated_text_default_wave_char_offset = _char_offset;
}

animated_text_default_wave(1000, 3, 0.5);


global.animated_text_default_float_cycle_time_ms = 1000;
global.animated_text_default_float_magnitude = 3;

/**
 * Set default values for the float animation.
 * @param {real} _cycle_time_ms time in ms per cycle
 * @param {real} _magnitude the magnitude of vertical motion the text will have
 */
function animated_text_default_float(_cycle_time_ms, _magnitude) {
	global.animated_text_default_float_cycle_time_ms = _cycle_time_ms;
	global.animated_text_default_float_magnitude = _magnitude;
}

animated_text_default_float(1000, 3);


global.animated_text_default_wobble_cycle_time_ms = 1000;
global.animated_text_default_wobble_max_angle = 10;

/**
 * Set default values for the wobble animation.
 * @param {real} _cycle_time_ms time in ms per cycle
 * @param {real} _max_angle maximum angle the wobble will reach in degree
 */
function animated_text_default_wobble(_cycle_time_ms, _max_angle) {
	global.animated_text_default_wobble_cycle_time_ms = _cycle_time_ms;
	global.animated_text_default_wobble_max_angle = _max_angle;
}

animated_text_default_wobble(1000, 10);


/**
 * @param {real} _animation_enum_value entry in the ANIMATED_TEXT_ANIMATIONS enum
 * @param {struct.StyleableText} _styleable_text reference to styleable text instance this animation acts on
 * @param {real} _index_start index of first character animation acts on
 * @param {real} _index_end index of last character animation acts on
 * @param {array} _aargs array of parameters for this animation
 * @ignore
 */
function AnimatedTextAnimation(_animation_enum_value, _styleable_text, _index_start, _index_end, _aargs) constructor {
	animation_enum_value = _animation_enum_value; // only needed for copying in outside contexts
	text_reference = _styleable_text;
	index_start = _index_start;
	index_end = _index_end;
	params = _aargs;
	
	/// @param {real} _update_time_ms
	update_merge = function(_update_time_ms) {};
	
	/// @param {real} _update_time_ms
	update_split = function(_update_time_ms) {
		text_reference.split_drawables_at(index_start, index_end);
	};
	
	/// @param {real} _update_time_ms
	update_animate = function(_update_time_ms) {};
	
	animation_finished = false; // finished animations are removed from whatever's using them
	time_ms = 0;
	
	if (_animation_enum_value == ANIMATED_TEXT_ANIMATIONS.FADEIN) {
		duration = global.animated_text_default_fadein_duration;
		
		if (array_length(params) == 1) {
			duration = params[0];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for fadein animation!", true);
		}
		
		update_merge = function(_update_time_ms) {
			text_reference.set_characters_hidden(index_start, index_end, false);
			if (time_ms < duration) return;
			animation_finished = true;
			text_reference.merge_drawables_at(index_start, index_end);
		};
		
		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			text_reference.set_alpha(index_start, index_end, time_ms/duration);
		};
	}
	
	if (_animation_enum_value == ANIMATED_TEXT_ANIMATIONS.RISEIN) {
		duration = global.animated_text_default_risein_duration;
		
		if (array_length(params) == 1) {
			duration = params[0];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for risein animation!", true);
		}
		
		update_merge = function(_update_time_ms) {
			text_reference.set_characters_hidden(index_start, index_end, false);
			if (time_ms < duration) return;
			animation_finished = true;
			text_reference.merge_drawables_at(index_start, index_end);
		};
		
		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			text_reference.set_mod_y(index_start, index_end, 5 - time_ms/duration*5);
		};
	}
	
	if (_animation_enum_value == ANIMATED_TEXT_ANIMATIONS.FADE) {
		alpha_min = global.animated_text_default_fade_alpha_min;
		alpha_max = global.animated_text_default_fade_alpha_max;
		cycle_time = global.animated_text_default_fade_cycle_time_ms;
		
		if (array_length(params) == 3) {
			alpha_min = params[0];
			alpha_max = params[1];
			cycle_time = params[2];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for fade animation!", true);
		}
		
		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			var _check = time_ms % (cycle_time * 2);
			if (_check <= cycle_time) {
				_check = cycle_time - _check;
			} else {
				_check -= cycle_time;
			}
			var _alpha = alpha_min + _check/cycle_time * (alpha_max - alpha_min);
			text_reference.set_alpha(index_start, index_end, _alpha);
		};
	}
	
	if (_animation_enum_value == ANIMATED_TEXT_ANIMATIONS.SHAKE || _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.TREMBLE) {
		offset_time = _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.SHAKE ? global.animated_text_default_shake_time_ms : global.animated_text_default_tremble_time_ms;
		magnitude = _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.SHAKE ? global.animated_text_default_shake_magnitude : global.animated_text_default_tremble_magnitude;
		
		offset_individual_chars = _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.TREMBLE;
		
		if (array_length(params) == 2) {
			offset_time = params[0];
			magnitude = params[1];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for shake/tremble animation!", true);
		}
		
		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			var _index_x = floor(time_ms / offset_time);
			var _index_y = _index_x + 4321; // arbitrary character index offset 
			if (offset_individual_chars) {
				for (var _i = index_start; _i <= index_end; _i++) {
					var _offset_x = floor((magnitude + 1) * 2 * animated_text_get_random(_index_x + _i * 4321)) - magnitude
					var _offset_y = floor((magnitude + 1) * 2 * animated_text_get_random(_index_y + _i * 4321)) - magnitude
					text_reference.set_mod_x(_i, _i, _offset_x);
					text_reference.set_mod_y(_i, _i, _offset_y);
				}
			} else {
				var _offset_x = floor((magnitude + 1) * 2 * animated_text_get_random(_index_x)) - magnitude;
				var _offset_y = floor((magnitude + 1) * 2 * animated_text_get_random(_index_y)) - magnitude;
				text_reference.set_mod_x(index_start, index_end, _offset_x);
				text_reference.set_mod_y(index_start, index_end, _offset_y);
			}
		};
	}
	
	if (_animation_enum_value == ANIMATED_TEXT_ANIMATIONS.CHROMATIC || _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.WCHROMATIC) {
		change_ms = _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.CHROMATIC ? global.animated_text_default_chromatic_change_ms : global.animated_text_default_wchromatic_change_ms;
		steps_per_change = _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.CHROMATIC ? global.animated_text_default_chromatic_steps_per_change : global.animated_text_default_wchromatic_steps_per_change;
		char_offset = _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.CHROMATIC ? global.animated_text_default_chromatic_char_offset : undefined;

		// use char offset to determine if chromatic or wchromatic
		if (char_offset == undefined) {
			if (array_length(params) == 2) {
				change_ms = params[0];
				steps_per_change = params[1];
			} else if (array_length(params) != 0) {
				show_error("Improper number of args for wchromatic animation!", true);
			}
		} else {
			if (array_length(params) == 3) {
				change_ms = params[0];
				steps_per_change = params[1];
				char_offset = params[2];
			} else if (array_length(params) != 0) {
				show_error("Improper number of args for chromatic animation!", true);
			}
		}

		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			var _index = floor(time_ms/change_ms) * steps_per_change;
			
			// use char offset to determine if chromatic or wchromatic
			if (char_offset != undefined) {
				for (var _i = index_start; _i <= index_end; _i++) {
					text_reference.set_color(_i, _i, animated_text_get_chromatic_color_at(_index + char_offset * _i));
				}
			} else {
				text_reference.set_color(index_start, index_end, animated_text_get_chromatic_color_at(_index));
			}	
		};
	}
	
	if (_animation_enum_value == ANIMATED_TEXT_ANIMATIONS.WAVE || _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.FLOAT) {
		cycle_time = _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.WAVE ? global.animated_text_default_wave_cycle_time_ms : global.animated_text_default_float_cycle_time_ms;
		magnitude = _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.WAVE ? global.animated_text_default_wave_magnitude : global.animated_text_default_float_magnitude;
		char_offset = _animation_enum_value == ANIMATED_TEXT_ANIMATIONS.WAVE ? global.animated_text_default_wave_char_offset : undefined;
		
		// use char offset to determine if wave or float
		if (char_offset == undefined) {
			if (array_length(params) == 2) {
				cycle_time = params[0];
				magnitude = params[1];
			} else if (array_length(params) != 0) {
				show_error("Improper number of args for float animation!", true);
			}
		} else {
			if (array_length(params) == 3) {
				cycle_time = params[0];
				magnitude = params[1];
				char_offset = params[2];
			} else if (array_length(params) != 0) {
				show_error("Improper number of args for wave animation!", true);
			}
		}

		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			var _time_into_cylce = time_ms % cycle_time;
			var _percent = _time_into_cylce / cycle_time;
			if (char_offset == undefined) {
				var _mod_y = sin(_percent * -2 * pi) * magnitude;
				text_reference.set_mod_y(index_start, index_end, _mod_y)
			} else {
				for (var _i = index_start; _i <= index_end; _i++) {
					var _mod_y = sin(_percent * -2 * pi + char_offset * _i) * magnitude;
					text_reference.set_mod_y(_i, _i, _mod_y);
				}
			}
		};
	}
}
