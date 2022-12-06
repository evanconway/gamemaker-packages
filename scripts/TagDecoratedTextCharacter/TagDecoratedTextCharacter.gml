/**
 * Create a new Tag Decorated Text Character.
 * @param {string} _character the character
 * @param {struct.TagDecoratedTextStyle} _style style of this character
 * @param {array<struct.TagDecoratedTextAnimation>} _animations array of animations for this character
 * @param {real} _line_index index of the line this character is on
 */
function TagDecoratedTextCharacter(_character, _style, _animations, _line_index) constructor {
	character = _character;
	added = false;
	style = _style;
	char_x = 0;
	char_y = 0;
	draw_set_font(style.font); // we need this to determine width and height
	char_width = string_width(character) * style.scale_x;
	char_height = string_height(character) * style.scale_y;
	line_index = _line_index;
	animations = _animations;
	sprite = spr_tag_decorated_text_default; // triggers feather typing
	sprite = undefined;
	
	/**
	 * Sets the sprite of this character. If sprite is set the characters string value will be ignored.
	 * @param {asset.GMSprite} _sprite GameMaker sprite
	 */
	set_sprite = function(_sprite) {
		sprite = _sprite;
		char_width = sprite_get_width(sprite) * style.scale_x;
		char_height = sprite_get_height(sprite) * style.scale_y;
	};
}

/**
 * Get empty array that feather recognizes as type TagDecoratedTextCharacter.
 */
function tag_decorated_text_get_empty_array_characters() {
	var _style = new TagDecoratedTextStyle();
	var _animations = tag_decorated_text_get_empty_array_animations();
	var _character = new TagDecoratedTextCharacter("c", _style, _animations, 0)
	return array_create(0, _character);
}
