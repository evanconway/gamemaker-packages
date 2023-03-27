/**
 * @param {string} _source_string the string with decorative tags
 */
function TagDecoratedText(_source_string, _default_effects = "", _width = -1, _height = -1) constructor {
	width = _width;
	height = _height;
	
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
	
	/*
	Our original design did not account for pagination. This variable is a remnant of that.
	What we do now is create a single instance of TypedAnimatedText, then split it up into
	multiple instances or "pages" if a height is provided. 
	*/
	var _typed_animated_text = new TypedAnimatedText(displayed_text, _width, _height);
	
	for (var _i = 0; _i < array_length(commands); _i++) {
		var _cmd = string_lower(commands[_i].command);
		var _aargs = commands[_i].aargs;
		
		// convert string index to array index for applying effects
		var _s = commands[_i].index_start - 1;
		var _e = commands[_i].index_end - 1;
		
		// colors
		if (_cmd == "aqua") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_aqua);
		if (_cmd == "black") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_black);
		if (_cmd == "blue") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_blue);
		if (_cmd == "dkgray" || _cmd == "dkgrey") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_dkgray);
		if (_cmd == "pink" || _cmd == "fuchsia") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_fuchsia);
		if (_cmd == "gray" || _cmd == "grey") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_gray);
		if (_cmd == "green") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_green);
		if (_cmd == "lime") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_lime);
		if (_cmd == "ltgray" || _cmd == "ltgrey") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_ltgray);
		if (_cmd == "maroon") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_maroon);
		if (_cmd == "navy") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_navy);
		if (_cmd == "olive") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_olive);
		if (_cmd == "orange") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_orange);
		if (_cmd == "purple") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_purple);
		if (_cmd == "red") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_red);
		if (_cmd == "silver") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_silver);
		if (_cmd == "teal") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_teal);
		if (_cmd == "white") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_white);
		if (_cmd == "yellow") _typed_animated_text.animated_text.text.set_default_color(_s, _e, c_yellow);
		if (_cmd == "rgb") _typed_animated_text.animated_text.text.set_default_color(_s, _e, make_color_rgb(_aargs[0], _aargs[1], _aargs[2]));
		
		// animations
		if (_cmd == "fade") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.FADE, _s, _e, _aargs);
		if (_cmd == "shake") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.SHAKE, _s, _e, _aargs);
		if (_cmd == "tremble") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.TREMBLE, _s, _e, _aargs);
		if (_cmd == "chromatic") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.CHROMATIC, _s, _e, _aargs);
		if (_cmd == "wchromatic") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.WCHROMATIC, _s, _e, _aargs);
		if (_cmd == "wave") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.WAVE, _s, _e, _aargs);
		if (_cmd == "float") _typed_animated_text.animated_text.add_animation(ANIMATED_TEXT_ANIMATIONS.FLOAT, _s, _e, _aargs);
		
		// entry animations
		if (_cmd == "fadein") {
			for (var _k = _s; _k <= _e; _k++) {
				_typed_animated_text.add_entry_animation_at(_i, ANIMATED_TEXT_ANIMATIONS.FADEIN, _aargs);
			}
		}
		if (_cmd == "risein") {
			for (var _k = _s; _k <= _e; _k++) {
				_typed_animated_text.add_entry_animation_at(_i, ANIMATED_TEXT_ANIMATIONS.RISEIN, _aargs);
			}
		}
		
		// other
		if (_cmd == "n" || _cmd == "br") _typed_animated_text.animated_text.text.set_new_line_at(_s, true);
		if (_cmd == "f" || _cmd == "font") _typed_animated_text.animated_text.text.set_default_font(_s, _e, _aargs[0]);
		if (_cmd == "a" || _cmd == "alpha") _typed_animated_text.animated_text.text.set_default_alpha(_s, _e, _aargs[0]);
		if (_cmd == "x") _typed_animated_text.animated_text.text.set_default_mod_x(_s, _e, _aargs[0]);
		if (_cmd == "y") _typed_animated_text.animated_text.text.set_default_mod_y(_s, _e, _aargs[0]);
		if (_cmd == "xy") {
			_typed_animated_text.animated_text.text.set_default_mod_x(_s, _e, _aargs[0]);
			_typed_animated_text.animated_text.text.set_default_mod_y(_s, _e, _aargs[1]);
		}
		if (_cmd == "scalex") _typed_animated_text.animated_text.text.set_default_scale_x(_s, _e, _aargs[0]);
		if (_cmd == "scaley") _typed_animated_text.animated_text.text.set_default_scale_y(_s, _e, _aargs[0]);
		if (_cmd == "scalexy") {
			_typed_animated_text.animated_text.text.set_default_scale_x(_s, _e, _aargs[0]);
			_typed_animated_text.animated_text.text.set_default_scale_y(_s, _e, _aargs[1]);
		}
		if (_cmd == "s" || _cmd == "sprite") _typed_animated_text.animated_text.text.set_default_sprite(_s, _aargs[0]);
	}
	
	pages = height > 0 ? _typed_animated_text.paginate(_width, _height) : [_typed_animated_text];
	
	page_current = 0;
	
	get_height = function() {
		return height > 0 ? height : pages[0].animated_text.text.get_height();
	}
	
	get_width = function() {
		return width > 0 ? width : pages[0].animated_text.text.get_width();
	}
	
	draw_border = function(_x, _y) {
		draw_set_alpha(1);
		draw_set_color(c_fuchsia);
		draw_rectangle(_x, _y, _x + get_width(), _y + get_height(), true);
	}
	
	advance = function() {
		if (!pages[page_current].get_typed()) pages[page_current].set_typed(true);
		else if (page_current < array_length(pages) - 1) {
			page_current++
			pages[page_current].reset_typing();
		}
	}
	
	
	/**
	 * @param {real} _x x position
	 * @param {real} _y y position
	 * @param {real} _alignment horizontal alignment
	 */
	draw = function(_x, _y, _alignment = fa_left) {
		global.drawables_drawn = 0;
		pages[page_current].draw(_x, _y, _alignment);
		pages[page_current].update(1000 / game_get_speed(gamespeed_fps));
		draw_border(_x, _y);
	};
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