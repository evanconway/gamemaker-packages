/**
 * Get a new StyleableCharacter instance.
 * @param {string} _character character
 */
function StyleableTextCharacter(_character) constructor {
	if (string_length(_character) != 1) {
		show_error("string _character must be length 1", true);
	}
	character = _character;
	sprite = spr_styleable_text_sprite_default; // treated as undefined
	line_index = 0;
	position_x = 0;
	position_y = 0;
	style = new StyleableTextStyle();
	
	get_width = function() {
		if (sprite != spr_styleable_text_sprite_default) {
			return sprite_get_width(sprite) * style.scale_x;
		}
		draw_set_font(style.font);
		return string_width(character) * style.scale_x;
	}
	
	get_height = function() {
		if (sprite != spr_styleable_text_sprite_default) {
			return sprite_get_height(sprite) * style.scale_y;
		}
		draw_set_font(style.font);
		return string_height(character) * style.scale_y;
	};
	
	hidden = false;
	
	/**
	 * Draw this character at the given xy position.
	 * @param {real} _x x position
	 * @param {real} _y y position
	 */
	draw = function(_x, _y) {
		draw_text_ext_transformed_color(
			_x + position_x + style.mod_x,
			_y + position_y + style.mod_y,
			character,
			0,
			get_width(),
			style.scale_x,
			style.scale_y,
			style.mod_angle,
			style.style_color,
			style.style_color,
			style.style_color,
			style.style_color,
			style.alpha
		);
	};
}

function styleable_text_get_empty_array_character() {
	return array_create(0, new StyleableTextCharacter("$"));
}
