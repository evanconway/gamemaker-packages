/**
 * Get a new StyleableCharacter instance.
 * @param {string} _character character
 * @ignore
 */
function StyleableTextCharacter(_character) constructor {
	if (string_length(_character) != 1) {
		show_error("string _character must be length 1", true);
	}
	character = _character;
	sprite = spr_styleable_text_sprite_default; // treated as undefined
	line_index = 0;
	new_line = false; // forces new line start on this character
	position_x = 0;
	position_y = 0;
	style = new StyleableTextStyle();
	
	drawable = undefined; // the drawable that draws this character
	
	get_width = function() {
		if (sprite != spr_styleable_text_sprite_default) {
			return sprite_get_width(sprite) * style.scale_x;
		}
		var _original = draw_get_font();
		draw_set_font(style.font);
		var _result = string_width(character) * style.scale_x;
		draw_set_font(_original);
		return _result;
	}
	
	get_height = function() {
		if (sprite != spr_styleable_text_sprite_default) {
			return sprite_get_height(sprite) * style.scale_y;
		}
		var _original = draw_get_font();
		draw_set_font(style.font);
		var _result = string_height(character) * style.scale_y;
		draw_set_font(_original);
		return _result;
	};
	
	hidden = false;
}
