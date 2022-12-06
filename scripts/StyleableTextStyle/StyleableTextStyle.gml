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
	}
}
