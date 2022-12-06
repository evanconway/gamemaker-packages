enum TAG_DECORATED_TEXT_COMMANDS {
	// colors
	RED,
	BLUE,
	GREEN,
	YELLOW,
	ORANGE,
	PURPLE,
	BLACK,
	WHITE,
	GRAY,
	LTGRAY,
	DKGRAY,
	TEAL,
	AQUA,
	FUCHSIA,
	LIME,
	MAROON,
	NAVY,
	OLIVE,
	SILVER,
	BROWN,
	PINK,
	RGB,
	
	// styles
	FONT,
	SCALE,
	ANGLE,
	ALPHA,
	OFFSET,
	
	// animations
	FADE,
	SHAKE,
	TREMBLE,
	CHROMATIC,
	WCHROMATIC,
	WAVE,
	FLOAT,
	WOBBLE,
	
	// other
	SPRITE
}

/**
 * Get entry in TAG_DECORATED_TEXT_COMMANDS enum from given string. Returns -1 if no matching entry found.
 * @param {string} _command The command as a string.
 */
function string_to_tag_decorated_text_command(_command) {
	_command = string_lower(_command);
	if (_command == "red") {
		return TAG_DECORATED_TEXT_COMMANDS.RED;
	}
	if (_command == "blue") {
		return TAG_DECORATED_TEXT_COMMANDS.BLUE;
	}
	if (_command == "green") {
		return TAG_DECORATED_TEXT_COMMANDS.GREEN;
	}
	if (_command == "yellow") {
		return TAG_DECORATED_TEXT_COMMANDS.YELLOW;
	}
	if (_command == "orange") {
		return TAG_DECORATED_TEXT_COMMANDS.ORANGE;
	}
	if (_command == "purple") {
		return TAG_DECORATED_TEXT_COMMANDS.PURPLE;
	}
	if (_command == "black") {
		return TAG_DECORATED_TEXT_COMMANDS.BLACK;
	}
	if (_command == "white") {
		return TAG_DECORATED_TEXT_COMMANDS.WHITE
	}
	if (_command == "gray" || _command == "grey") {
		return TAG_DECORATED_TEXT_COMMANDS.GRAY;
	}
	if (_command == "ltgray" || _command == "ltgrey") {
		return TAG_DECORATED_TEXT_COMMANDS.LTGRAY;
	}
	if (_command == "dkgray" || _command == "dkgrey") {
		return TAG_DECORATED_TEXT_COMMANDS.DKGRAY;
	}
	if (_command == "teal") {
		return TAG_DECORATED_TEXT_COMMANDS.TEAL;
	}
	if (_command == "aqua") {
		return TAG_DECORATED_TEXT_COMMANDS.AQUA;
	}
	if (_command == "fuchsia") {
		return TAG_DECORATED_TEXT_COMMANDS.FUCHSIA;
	}
	if (_command == "lime") {
		return TAG_DECORATED_TEXT_COMMANDS.LIME;
	}
	if (_command == "maroon") {
		return TAG_DECORATED_TEXT_COMMANDS.MAROON;
	}
	if (_command == "navy") {
		return TAG_DECORATED_TEXT_COMMANDS.NAVY;
	}
	if (_command == "olive") {
		return TAG_DECORATED_TEXT_COMMANDS.OLIVE;
	}
	if (_command == "silver") {
		return TAG_DECORATED_TEXT_COMMANDS.SILVER;
	}
	if (_command == "brown") {
		return TAG_DECORATED_TEXT_COMMANDS.BROWN;
	}
	if (_command == "pink") {
		return TAG_DECORATED_TEXT_COMMANDS.PINK;
	}
	if (_command == "rgb") {
		return TAG_DECORATED_TEXT_COMMANDS.RGB;
	}
	if (_command == "font") {
		return TAG_DECORATED_TEXT_COMMANDS.FONT;
	}
	if (_command == "scale") {
		return TAG_DECORATED_TEXT_COMMANDS.SCALE;
	}
	if (_command == "angle") {
		return TAG_DECORATED_TEXT_COMMANDS.ANGLE;
	}
	if (_command == "alpha") {
		return TAG_DECORATED_TEXT_COMMANDS.ALPHA;
	}
	if (_command == "offset") {
		return TAG_DECORATED_TEXT_COMMANDS.OFFSET;
	}
	if (_command == "fade") {
		return TAG_DECORATED_TEXT_COMMANDS.FADE;
	}
	if (_command == "shake") {
		return TAG_DECORATED_TEXT_COMMANDS.SHAKE;
	}
	if (_command == "tremble") {
		return TAG_DECORATED_TEXT_COMMANDS.TREMBLE;
	}
	if (_command == "chromatic") {
		return TAG_DECORATED_TEXT_COMMANDS.CHROMATIC;
	}
	if (_command == "wchromatic") {
		return TAG_DECORATED_TEXT_COMMANDS.WCHROMATIC;
	}
	if (_command == "wave") {
		return TAG_DECORATED_TEXT_COMMANDS.WAVE;
	}
	if (_command == "float") {
		return TAG_DECORATED_TEXT_COMMANDS.FLOAT;
	}
	if (_command == "wobble") {
		return TAG_DECORATED_TEXT_COMMANDS.WOBBLE;
	}
	if (_command == "sprite") {
		return TAG_DECORATED_TEXT_COMMANDS.SPRITE;
	}
	return -1;
}

/**
 * A struct to contain a command and arguments derived from parsed text.
 * @param {real} _command The command from the tag decorated text commands enum to be applied to the text.
 * @param {array<any>} _command_arguments Arguments for the given command.
 */
function TagDecoratedTextCommand(_command, _command_arguments) constructor {	
	command = _command;
	aargs = _command_arguments;
	
	/**
	 * Converts this command into an rgb command with correct args.
	 * @param {real} _red Red hue of the color.
	 * @param {real} _green Green hue of the color.
	 * @param {real} _blue Blue hue of the color.
	 * @ignore
	 */
	convert_to_rgb = function(_red, _green, _blue) {
		array_resize(aargs, 3);
		aargs[0] = _red;
		aargs[1] = _green;
		aargs[2] = _blue;
		command = TAG_DECORATED_TEXT_COMMANDS.RGB;
	}
	
	/*
	We automatically convert any color commands into rgb commands with equivalent
	arguments. This makes it more convenient to work with Command instances in
	other contexts.
	*/
	if (command == TAG_DECORATED_TEXT_COMMANDS.RED) {
		convert_to_rgb(color_get_red(c_red), color_get_green(c_red), color_get_blue(c_red));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.BLUE) {
		convert_to_rgb(color_get_red(c_blue), color_get_green(c_blue), color_get_blue(c_blue));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.GREEN) {
		convert_to_rgb(color_get_red(c_green), color_get_green(c_green), color_get_blue(c_green));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.YELLOW) {
		convert_to_rgb(color_get_red(c_yellow), color_get_green(c_yellow), color_get_blue(c_yellow));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.ORANGE) {
		convert_to_rgb(color_get_red(c_orange), color_get_green(c_orange), color_get_blue(c_orange));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.PURPLE) {
		convert_to_rgb(color_get_red(c_purple), color_get_green(c_purple), color_get_blue(c_purple));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.BLACK) {
		convert_to_rgb(color_get_red(c_black), color_get_green(c_black), color_get_blue(c_black));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.WHITE) {
		convert_to_rgb(color_get_red(c_white), color_get_green(c_white), color_get_blue(c_white));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.GRAY) {
		convert_to_rgb(color_get_red(c_gray), color_get_green(c_gray), color_get_blue(c_gray));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.LTGRAY) {
		convert_to_rgb(color_get_red(c_ltgray), color_get_green(c_ltgray), color_get_blue(c_ltgray));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.DKGRAY) {
		convert_to_rgb(color_get_red(c_dkgray), color_get_green(c_dkgray), color_get_blue(c_dkgray));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.TEAL) {
		convert_to_rgb(color_get_red(c_teal), color_get_green(c_teal), color_get_blue(c_teal));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.AQUA) {
		convert_to_rgb(color_get_red(c_aqua), color_get_green(c_aqua), color_get_blue(c_aqua));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.FUCHSIA) {
		convert_to_rgb(color_get_red(c_fuchsia), color_get_green(c_fuchsia), color_get_blue(c_fuchsia));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.LIME) {
		convert_to_rgb(color_get_red(c_lime), color_get_green(c_lime), color_get_blue(c_lime));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.MAROON) {
		convert_to_rgb(color_get_red(c_maroon), color_get_green(c_maroon), color_get_blue(c_maroon));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.NAVY ) {
		convert_to_rgb(color_get_red(c_navy), color_get_green(c_navy), color_get_blue(c_navy));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.OLIVE) {
		convert_to_rgb(color_get_red(c_olive), color_get_green(c_olive), color_get_blue(c_olive));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.SILVER) {
		convert_to_rgb(color_get_red(c_silver), color_get_green(c_silver), color_get_blue(c_silver));
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.BROWN) {
		convert_to_rgb(102, 51, 0);
	}
	if (command == TAG_DECORATED_TEXT_COMMANDS.PINK) {
		convert_to_rgb(255, 51, 255);
	}
}

/**
 * Get an empty array that feather will recognize as type TagDecoratedTextCommands.
 */
function tag_decorated_text_get_empty_array_commands() {
	var _command = new TagDecoratedTextCommand(TAG_DECORATED_TEXT_COMMANDS.FADE, []);
	return array_create(0, _command);
}
