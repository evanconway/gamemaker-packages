enum ANIMATED_TEXT_ANIMATIONS {
	FADEIN,
	RISEIN,
	WAVE
}

// DEFAULTS
global.animated_text_default_fade_alpha_min = 0.3;
global.animated_text_default_fade_alpha_max = 1;
global.animated_text_default_fade_cycle_time_ms = 1000;

/**
 * @desc Set default values for fade animation.
 * @param {real} _alpha_min minimum alpha
 * @param {real} _alpha_max maximum alpha
 * @param {real} _cycle_time_ms time in ms for one cycle of animation
 */
function animated_text_set_default_fade(_alpha_min, _alpha_max, _cycle_time_ms) {
	global.animated_text_default_fade_alpha_min = _alpha_min;
	global.animated_text_default_fade_alpha_max = _alpha_max;
	global.animated_text_default_fade_cycle_time_ms = _cycle_time_ms;
}

global.animated_text_default_shake_time_ms = 80;
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

global.animated_text_default_tremble_time_ms = 80;
global.animated_text_default_tremble_magnitude = 2;

/**
 * Set default values for tremble animation.
 * @param {real} _time_ms time in ms text is held out of place
 * @param {real} _magnitude magnitude in pixels text can be offset by
 */
function animated_text_default_tremble(_time_ms, _magnitude) {
	global.animated_text_default_tremble_time_ms = _time_ms;
	global.animated_text_default_tremble_magnitude = _magnitude;
}

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

global.animated_text_default_float_cycle_time_ms = 1000;
global.animated_text_default_float_magnitude = 3;

/**
 * Set default values for the float animation.
 * @param {real} _cycle_time_ms time in ms per cycle
 * @param {real} _magnitude the magnitude of vertical motion the text will have
 */
function animated_text_default_float(_cycle_time_ms, _magnitude) {
	global.animated_text_default_float_cycle_time = _cycle_time_ms;
	global.animated_text_default_float_magnitude = _magnitude;
}

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


/**
 * @param {real} _animation_enum_value entry in the ANIMATED_TEXT_ANIMATIONS enum
 * @param {struct.StyleableText} _styleable_text reference to styleable text instance this animation acts on
 * @param {real} _index_start index of first character animation acts on
 * @param {real} _index_end index of last character animation acts on
 * @param {array} _aargs array of parameters for this animation
 */
function AnimatedTextAnimation(_animation_enum_value, _styleable_text, _index_start, _index_end, _aargs) constructor {
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
		duration = 200;
		
		update_merge = function(_update_time_ms) {
			text_reference.set_characters_hidden(index_start, index_end, false);
			if (time_ms < duration) return;
			animation_finished = true;
			text_reference.merge_drawables_at(index_start, index_end);
		};
		
		/// @param {real} _update_time_ms
		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			text_reference.set_alpha(index_start, index_end, time_ms/duration);
		};
	}
	
	if (_animation_enum_value == ANIMATED_TEXT_ANIMATIONS.RISEIN) {
		duration = 200;
		
		update_merge = function(_update_time_ms) {
			text_reference.set_characters_hidden(index_start, index_end, false);
			if (time_ms < duration) return;
			animation_finished = true;
			text_reference.merge_drawables_at(index_start, index_end);
		};
		
		/// @param {real} _update_time_ms
		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			text_reference.set_mod_y(index_start, index_end, 5 - time_ms/duration*5);
		};
	}
	
	if (_animation_enum_value == ANIMATED_TEXT_ANIMATIONS.WAVE) {
		cycle_time = global.animated_text_default_wave_cycle_time_ms;
		magnitude = global.animated_text_default_wave_magnitude;
		char_offset = global.animated_text_default_wave_char_offset;
		
		if (array_length(params) == 3) {
			cycle_time = params[0];
			magnitude = params[1];
			char_offset = params[2];
		} else if (array_length(params) != 0) {
			show_error("Improper number of args for wave animation!", true);
		}
		
		/// @param {real} _update_time_ms
		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			var _time_into_cylce = time_ms % cycle_time;
			var _percent = _time_into_cylce / cycle_time;
			for (var _i = index_start; _i <= index_end; _i++) {
				var _mod_y = sin(_percent * -2 * pi + char_offset * _i) * magnitude;
				text_reference.set_mod_y(_i, _i, _mod_y);
			}
		};
	}
}

function animated_text_get_empty_array_animation() {
	var _text = new StyleableText("$");
	var _animation = new AnimatedTextAnimation(ANIMATED_TEXT_ANIMATIONS.FADEIN, _text, 0, 0, []);
	return array_create(0, _animation);
}
