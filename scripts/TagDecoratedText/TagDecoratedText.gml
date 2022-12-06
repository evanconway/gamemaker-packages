/**
 * Create a new Tag Decorated Text element.
 * @param {string} _source_string The text, including command tags, to generate a Tag Decorated Text element from.
 */
function TagDecoratedText(_source_string) constructor {
	source = "";
	characters = tag_decorated_text_get_empty_array_characters();
	default_style = new TagDecoratedTextStyle();
	max_width = 400;
	drawables = tag_decorated_text_get_undefined_drawable();
	drawables = undefined;
	drawables_end = drawables;
	create_drawables_on_set_text = true;
	update_time_ms = 0;
	
	/*
	Keep track of line index and line width while parsing text. We use line width to determine
	when a new line of text should happen, and we keep track of which line the characters are
	on with the line index. This function should be invoked whenever a non-space character
	is added to the character array.
	*/
	line_width = 0;
	line_index = 0;
	/**
	 * Adds a character to the character array. Should only be used during text parsing.
	 *@param {struct.TagDecoratedTextCharacter} _character
	 */
	add_character = function(_character) {
		array_push(characters, _character);
		line_width += _character.char_width;
		if (line_width <= max_width || _character.character == " ") return;
		line_index++;
		line_width = 0;
		var _i = array_length(characters) - 1;
		while (_i >= 0 && characters[_i].character != " ") {
			characters[_i].line_index = line_index;
			line_width += characters[_i].char_width;
			_i--;
		}
	};
	
	add_drawable = function(_character_index) {
		var _c = characters[_character_index];
		if (_c.added) {
			return;
		}
		_c.added = true;
		var _drawable = new TagDecoratedTextDrawable(characters, _character_index);
		if (drawables == undefined) {
			drawables = _drawable;
			drawables_end = _drawable;
		} else {
			_drawable.previous = drawables_end;
			drawables_end.next = _drawable;
			_drawable.merge();
			while (drawables_end.next != undefined) drawables_end = drawables_end.next;
		}
	};
	
	/**
	 * Set the x and y position of all characters.
	 */
	set_characters_xy = function() {
		var _line_heights = ds_map_create();
		for (var _i = 0; _i < array_length(characters); _i++) {
			var _c = characters[_i];
			if (ds_map_exists(_line_heights, _c.line_index) && _c.char_height > _line_heights[? _c.line_index]) {
				_line_heights[? _c.line_index] = _c.char_height;
			} else {
				ds_map_add(_line_heights, _c.line_index, _c.char_height);
			}
		}
		var _x = 0;
		var _y = 0;
		var _line_i_prev = 0;
		var _c;
		for (var _i = 0; _i < array_length(characters); _i++) {
			_c = characters[_i];
			if (_c.line_index != _line_i_prev) {
				_x = 0;
				_y += _line_heights[? _line_i_prev];
				_line_i_prev = _c.line_index;
			}
			_c.char_x = _x;
			_x += _c.char_width;
			_c.char_y = _y;
			if (create_drawables_on_set_text) {
				add_drawable(_i);
			}
		}
		ds_map_destroy(_line_heights);
	};
	
	/**
	 * Set the text of this TagDecoratedText element.
	 * @param {string} _new_source_string
	 */
	set_text = function(_new_source_string) {
		source = _new_source_string;
		var _commands = tag_decorated_text_get_empty_array_commands();
		for (var _i = 1; _i <= string_length(source); _i++) {
			var _char = string_char_at(source, _i);
			if (_char == "<") {
				_commands = parse_commands_at(_i);
				var _sprite = get_sprite_from_commands(_commands);
				if (_sprite != undefined) {
					var _style = default_style.copy_with_commands_applied(_commands);
					var _animations = get_animations_from_commands(_commands, array_length(characters));
					var _sprite_character = new TagDecoratedTextCharacter("$", _style, _animations, line_index);
					_sprite_character.set_sprite(_sprite);
					add_character(_sprite_character);
				}
				_i = string_pos_ext(">", source, _i);
			} else {
				var _style = default_style.copy_with_commands_applied(_commands);
				var _animations = get_animations_from_commands(_commands, array_length(characters));
				var _character = new TagDecoratedTextCharacter(_char, _style, _animations, line_index);
				add_character(_character);
			}
		}
		
		set_characters_xy();
	}
	
	/**
	 * Parse out an array of commands at the given index in the source.
	 * @param {real} _index index in the source to parse commands from
	 */
	parse_commands_at = function(_index) {
		var _end_index = string_pos_ext(">", source, _index);
		var _string_to_parse = string_copy(source, _index + 1, _end_index - (_index + 1));
		var _to_parse = string_split(_string_to_parse, " ");
		var _result = array_create(0, new TagDecoratedTextCommand(0, []));
		for (var _i = 0; _i < array_length(_to_parse); _i++) {
			var _command_and_aargs = string_split(_to_parse[_i], ":");
			var _command = string_to_tag_decorated_text_command(_command_and_aargs[0]);
			var _aargs = array_length(_command_and_aargs) == 1 ? [] : array_map(string_split(_command_and_aargs[1], ",", true), function(_value) {
				try {
					var _number = real(_value);
					_value = _number;
				} catch (e) {
					// do nothing
				}
				return _value;
			});
			array_push(_result, new TagDecoratedTextCommand(_command, _aargs));
		}
		return _result;
	};
	
	/**
	 * Get the sprite asset in the given command array, if there is one.
	 * @param {array<struct.TagDecoratedTextCommand>} _commands command array
	 */
	get_sprite_from_commands = function(_commands) {
		var _result = spr_tag_decorated_text_default;
		_result = undefined;
		for (var _i = 0; _i < array_length(_commands); _i ++) {
			if (_commands[_i].command == TAG_DECORATED_TEXT_COMMANDS.SPRITE) {
				if (array_length(_commands[_i].aargs) == 1) {
					if (asset_get_type(_commands[_i].aargs[0]) != asset_sprite) {
						show_error("TDT Error: Given sprite \"" + _commands[_i].aargs[0] + "\" does not exist!", true);
					}
					_result = asset_get_index(_commands[_i].aargs[0]);
				} else {
					show_error("TDT Error: Improper number of args for sprite!", true);
				}
			}
		}
		return _result;
	};
	
	/**
	 * Get an array of animations given an array of commands and character index.
	 * @param {array<struct.TagDecoratedTextCommand>} _commands array of commands to parse animations from
	 * @param {real} _char_index index in char array animations will refer to
	 */
	get_animations_from_commands = function(_commands, _char_index) {
		var _result = tag_decorated_text_get_empty_array_animations();
		for (var _i = 0; _i < array_length(_commands); _i++) {
			var _animation = new TagDecoratedTextAnimation(_commands[_i].command, _commands[_i].aargs, _char_index);
			if (_animation.valid_animation_command) array_push(_result, _animation);
		}
		return _result;
	};
	
	set_text(_source_string);
	
	update_custom_time = function(_time_ms) {
		update_time_ms += _time_ms;
		var _cursor = drawables;
		while (_cursor != undefined) {
			_cursor.update(update_time_ms);
			_cursor = _cursor.next;
		}
	};
	
	update = function() {
		update_custom_time(1000 / game_get_speed(gamespeed_fps));
	};
	
	/**
	 * Draw this TagDecoratedText instance at the given x y position without updating.
	 * @param {real} _x x position
	 * @param {real} _y y position
	 */
	draw_no_update = function(_x, _y) {
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)
		var _cursor = drawables;
		while (_cursor != undefined) {
			_cursor.draw(_x, _y);
			_cursor = _cursor.next;
		}
		draw_set_color(c_fuchsia);
		draw_rectangle(_x, _y, _x + max_width, _y + 480, true);
		
	};
	
	/**
	 * Draw this TagDecoratedText instance at the given x y position.
	 * @param {real} _x x position
	 * @param {real} _y y position
	 */
	draw = function(_x, _y) {
		update();
		draw_no_update(_x, _y);
	};
}
