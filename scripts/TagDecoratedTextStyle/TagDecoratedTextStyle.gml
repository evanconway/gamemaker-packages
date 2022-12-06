/**
 * Create a new tag decorated text style struct with default styles.
 */
function TagDecoratedTextStyle() constructor {
	font = fnt_tag_decorated_text_font_default;
	style_color = c_white;
	alpha = 1;
	scale_x = 1;
	scale_y = 1;
	mod_x = 0;
	mod_y = 0;
	mod_angle = 0;
	
	/**
	 * Returns a new style object that's an exact copy of this one.
	 */
	copy = function() {
		var _result = new TagDecoratedTextStyle();
		_result.font = font;
		_result.style_color = style_color;
		_result.alpha = alpha;
		_result.scale_x = scale_x;
		_result.scale_y = scale_y;
		_result.mod_x = mod_x;
		_result.mod_y = mod_y;
		_result.mod_angle = mod_angle;
		return _result;
	}
	
	/**
	 * Get a copy of this style with the given commands applied
	 * @param {array<struct.TagDecoratedTextCommand>} _commands The array of commands to apply to this style.
	 */
	copy_with_commands_applied = function(_commands) {
		var _result = copy();
		for (var _i = 0; _i < array_length(_commands); _i++) {
			var _command = _commands[_i].command; 
			var _aargs = _commands[_i].aargs;
			if (_command == TAG_DECORATED_TEXT_COMMANDS.RGB) {
				_result.style_color = make_color_rgb(_aargs[0], _aargs[1], _aargs[2]);
			}
			if (_command == TAG_DECORATED_TEXT_COMMANDS.FONT) {
				if (array_length(_aargs) != 1) {
					show_error("TDS: Incorrect number of args for font style.", true);
				}
				if (asset_get_type(_aargs[0]) != asset_font) {
					show_error("TDS: Unrecognized font name: " + _aargs[0], true);
				}
				_result.font = asset_get_index(_aargs[0]);
			}
			if (_command == TAG_DECORATED_TEXT_COMMANDS.SCALE) {
				if (array_length(_aargs) != 2) {
					show_error("TDS: Incorrect number of args for scale style.", true);
				}
				_result.scale_x = _aargs[0];
				_result.scale_y = _aargs[1];
			}
			if (_command == TAG_DECORATED_TEXT_COMMANDS.ANGLE) {
				if (array_length(_aargs) != 1) {
					show_error("TDS: Incorrect number of args for angle style.", true);
				}
				_result.mod_angle = _aargs[0];
			}
			if (_command == TAG_DECORATED_TEXT_COMMANDS.ALPHA) {
				if (array_length(_aargs) != 1) {
					show_error("TDS: Incorrect number of args for alpha style.", true);
				}
				_result.alpha = _aargs[0];
			}
			if (_command == TAG_DECORATED_TEXT_COMMANDS.OFFSET) {
				if (array_length(_aargs) != 2) {
					show_error("TDS: Incorrect number of args for offset style.", true)
				}
				_result.mod_x = _aargs[0];
				_result.mod_y = _aargs[1];
			}
		}
		return _result;
	}
	
	/**
	 * Returns a boolean indicating if the given style object is equal to this one.
	 * @param {struct.TagDecoratedTextStyle} _style The style object to compare to.
	 * @returns {bool}
	 */
	is_equal = function(_style) {
		if (_style.alpha != alpha) return false;
		if (_style.font != font) return false;
		if (_style.mod_angle != mod_angle) return false;
		if (_style.mod_x != mod_x) return false;
		if (_style.mod_y != mod_y) return false;
		if (_style.scale_x != scale_x) return false;
		if (_style.scale_y != scale_y) return false;
		if (_style.style_color != style_color) return false;
		return true;
	}
	
	/**
	 * Sets each variable in this style to undefined.
	 * @self
	 */
	set_undefined = function() {
		font = undefined;
		style_color = undefined;
		alpha = undefined;
		scale_x = undefined;
		scale_y = undefined;
		mod_x = undefined;
		mod_y = undefined;
		mod_angle = undefined;
	}
}
