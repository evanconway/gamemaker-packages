/**
 * Get a new StyleableTextStyle instance.
 */
function StyleableTextStyle() constructor {
	font = fnt_styleable_text_font_default;
	style_color = c_white;
	alpha = 1;
	scale_x = 1;
	scale_y = 1;
	mod_x = 0;
	mod_y = 0;
	mod_angle = 0;
	
	/**
	 * Get boolean indicating if the given style is equal to this one.
	 * @param {struct.StyleableTextStyle} _style style
	 */
	is_equal = function(_style) {
		if (_style.font != font) return false;
		if (_style.style_color != style_color) return false;
		if (_style.alpha != alpha) return false;
		if (_style.scale_x != scale_x) return false;
		if (_style.scale_y != scale_y) return false;
		if (_style.mod_x != mod_x) return false;
		if (_style.mod_y != mod_y) return false;
		if (_style.mod_angle != mod_angle) return false;
		return true;
	};
	
	/**
	 * Returns a new style object that's an exact copy of this one.
	 */
	copy = function() {
		var _result = new StyleableTextStyle();
		_result.font = font;
		_result.style_color = style_color;
		_result.alpha = alpha;
		_result.scale_x = scale_x;
		_result.scale_y = scale_y;
		_result.mod_x = mod_x;
		_result.mod_y = mod_y;
		_result.mod_angle = mod_angle;
		return _result;
	};
}
