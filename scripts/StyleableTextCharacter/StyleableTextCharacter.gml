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
			draw_set_font(style.font);
			return string_width(character) * style.scale_x;
		}
		draw_set_font(style.font);
		return string_width(character) * style.scale_x;
	}
	get_height = function() {
		if (sprite != spr_styleable_text_sprite_default) {
			return sprite_get_height(sprite) * style.scale_y;
			draw_set_font(style.font);
			return string_height(character) * style.scale_y;
		}
		draw_set_font(style.font);
		return string_height(character) * style.scale_y;
	};
}

function styleable_text_get_empty_array_character() {
	return array_create(0, new StyleableTextCharacter("$"));
}
