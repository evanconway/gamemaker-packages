/**
 * @param {string} _source_string the string with decorative tags
 */
function TagDecoratedText(_source_string, _default_effects = "", _width = 600, _height = -1) constructor {
	/*
	The source string contains both the tags and the text to actually display. From
	this we need to build an array of commands and their index ranges as well as 
	the text to display with command tags removed.
	*/
	
	commands = [];
	
	set_command_unset_ends = function(_end_index) {
		for (var _k = array_length(commands) - 1; _k >= 0; _k--) {
			if (commands[_k].index_end < 0) {
				commands[_k].index_end = _end_index;
			} else {
				_k = -1; // end loop if index_end defined
			}
		}
	};
	
	displayed_text = "";
	
	var _index = 1;
	
	// parse out commands and displayed text
	for (var _i = 1; _i <= string_length(_source_string); _i++) {
		var _c = string_char_at(_source_string, _i);
		var _c_next = string_char_at(_source_string, _i + 1);
		
		// handle command
		if (_c == "<" && _c_next != ">" && _c_next != "") {
			var _end_index = string_pos_ext(">", _source_string, _i + 1);
			var _command_text = string_copy(_source_string, _i + 1, _end_index - _i - 1);
			var _command_arr = string_split(_command_text, " ", true);
			for (var _k = 0; _k < array_length(_command_arr); _k++) {
				array_push(commands, new TagDecoratedTextCommand(_command_arr[_k], _index));
			}
			_i = _end_index;
		}
		
		// handle clear tag
		if (_c == "<" && _c_next == ">") {
			set_command_unset_ends(_index - 1);
			_i++;
		}
		
		// handle error
		if (_c == "<" && _c_next == "") {
			show_error("Improper tags used in tag decorated text!", true);
		}
		
		// handle regular text
		if (_c != "<") {
			displayed_text += _c;
			_index++;
		}
	}
	
	set_command_unset_ends(string_length(displayed_text));
	
	// before parsing commands, apply defaults
	var _default_commands = [];
	var _default_command_arr = string_split(_default_effects, " ", true);
	for (var _d = 0; _d < array_length(_default_command_arr); _d++) {
		var _new_command = new TagDecoratedTextCommand(_default_command_arr[_d], 1);
		_new_command.index_end = string_length(displayed_text);
		array_push(_default_commands, _new_command);
	}
	while (array_length(_default_commands) > 0) {
		array_insert(commands, 0, array_pop(_default_commands));
	}
	
	typed_animated_text = new TypedAnimatedText(displayed_text, _width, _height);
	
	/// @param {Struct.TagDecoratedTextCommand} _command_to_apply
	var _f_apply_command = function(_command_to_apply) {
		var _cmd = string_lower(_command_to_apply.command);
		var _aargs = _command_to_apply.aargs;
		
		// conver string index to array index for applying effects
		var _s = _command_to_apply.index_start - 1;
		var _e = _command_to_apply.index_end - 1;
		
		// colors
		if (_cmd == "aqua") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_aqua);
		if (_cmd == "black") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_black);
		if (_cmd == "blue") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_blue);
		if (_cmd == "dkgray" || _cmd == "dkgrey") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_dkgray);
		if (_cmd == "pink" || _cmd == "fuchsia") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_fuchsia);
		if (_cmd == "gray" || _cmd == "grey") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_gray);
		if (_cmd == "green") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_green);
		if (_cmd == "lime") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_lime);
		if (_cmd == "ltgray" || _cmd == "ltgrey") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_ltgray);
		if (_cmd == "maroon") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_maroon);
		if (_cmd == "navy") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_navy);
		if (_cmd == "olive") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_olive);
		if (_cmd == "orange") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_orange);
		if (_cmd == "purple") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_purple);
		if (_cmd == "red") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_red);
		if (_cmd == "silver") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_silver);
		if (_cmd == "teal") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_teal);
		if (_cmd == "white") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_white);
		if (_cmd == "yellow") typed_animated_text.animated_text.text.set_default_color(_s, _e, c_yellow);
		if (_cmd == "rgb") typed_animated_text.animated_text.text.set_default_color(_s, _e, make_color_rgb(_aargs[0], _aargs[1], _aargs[2]));
		
		// animations
		if (_cmd == "fade") typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.FADE, _s, _e, _aargs);
		if (_cmd == "shake") typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.SHAKE, _s, _e, _aargs);
		if (_cmd == "tremble") typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.TREMBLE, _s, _e, _aargs);
		if (_cmd == "chromatic") typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.CHROMATIC, _s, _e, _aargs);
		if (_cmd == "wchromatic") typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.WCHROMATIC, _s, _e, _aargs);
		if (_cmd == "wave") typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.WAVE, _s, _e, _aargs);
		if (_cmd == "float") typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.FLOAT, _s, _e, _aargs);
		
		// entry animations
		if (_cmd == "fadein") {
			for (var _i = _s; _i <= _e; _i++) {
				typed_animated_text.add_entry_animation_at(_i, ANIMATED_TEXT_ANIMATIONS.FADEIN, _aargs);
			}
		}
		if (_cmd == "risein") {
			for (var _i = _s; _i <= _e; _i++) {
				typed_animated_text.add_entry_animation_at(_i, ANIMATED_TEXT_ANIMATIONS.RISEIN, _aargs);
			}
		}
		
		// other
		if (_cmd == "n" || _cmd == "br") typed_animated_text.animated_text.text.set_new_line_at(_s, true);
		if (_cmd == "f" || _cmd == "font") typed_animated_text.animated_text.text.set_default_font(_s, _e, _aargs[0]);
		if (_cmd == "a" || _cmd == "alpha") typed_animated_text.animated_text.text.set_default_alpha(_s, _e, _aargs[0]);
		if (_cmd == "x") typed_animated_text.animated_text.text.set_default_mod_x(_s, _e, _aargs[0]);
		if (_cmd == "y") typed_animated_text.animated_text.text.set_default_mod_y(_s, _e, _aargs[0]);
		if (_cmd == "xy") {
			typed_animated_text.animated_text.text.set_default_mod_x(_s, _e, _aargs[0]);
			typed_animated_text.animated_text.text.set_default_mod_y(_s, _e, _aargs[1]);
		}
		if (_cmd == "scalex") typed_animated_text.animated_text.text.set_default_scale_x(_s, _e, _aargs[0]);
		if (_cmd == "scaley") typed_animated_text.animated_text.text.set_default_scale_y(_s, _e, _aargs[0]);
		if (_cmd == "scalexy") {
			typed_animated_text.animated_text.text.set_default_scale_x(_s, _e, _aargs[0]);
			typed_animated_text.animated_text.text.set_default_scale_y(_s, _e, _aargs[1]);
		}
		if (_cmd == "s" || _cmd == "sprite") typed_animated_text.animated_text.text.set_default_sprite(_s, _aargs[0]);
	};
	
	array_foreach(commands, _f_apply_command);
	
	get_height = function() {
		return typed_animated_text.animated_text.text.get_height();
	}
	
	get_width = function() {
		return typed_animated_text.animated_text.text.get_width();
	}
	
	draw_border = function(_x, _y) {
		draw_set_alpha(1);
		draw_set_color(c_fuchsia);
		draw_rectangle(_x, _y, _x + get_width(), _y + get_height(), true);
	}
	
	/**
	 * @param {real} _x x position
	 * @param {real} _y y position
	 * @param {real} _alignment horizontal alignment
	 */
	draw = function(_x, _y, _alignment = fa_left) {
		global.drawables_drawn = 0;
		typed_animated_text.draw(_x, _y, _alignment);
		draw_border(_x, _y);
	};
	
	typed_animated_text.set_typed(true);
}

/**
 * @ignore
 * @param {string} _command
 * @param {real} _index_start
 */
function TagDecoratedTextCommand(_command, _index_start) constructor {
	var _command_aarg_split = string_split(_command, ":");
	command = _command_aarg_split[0];
	var _aarg_string = array_length(_command_aarg_split) > 1 ? _command_aarg_split[1] : "";
	
	var _f_map = function(_string) {
		try {
			var _r = real(_string);
			return _r
		} catch(_error) {
			_error = undefined;
		}

		// Feather disable once GM1035
		return _string;
	};
	
	aargs = _aarg_string == "" ? [] : array_map(string_split(_aarg_string, ","), _f_map);
	
	index_start = _index_start;
	index_end = -1;
}

function tag_decorated_text_draw_performance(_x, _y) {
	draw_set_color(c_lime);
	draw_set_alpha(1);
	draw_text(0, 0, fps_real);
	draw_text(0, 20, "drawables: " + string(global.drawables_drawn));
}