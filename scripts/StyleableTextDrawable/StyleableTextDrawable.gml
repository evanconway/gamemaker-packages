/**
 * Get a new StyleableTextDrawable instance.
 * @param {array<struct.StyleableTextCharacter>} _character_array reference to a StyleableTextCharacter array
 * @param {real} _index_start index of first character this drawable references, inclusive
 * @param {real} _index_end index of last character this drawable references, inclusive
 */
function StyleableTextDrawable(_character_array, _index_start, _index_end) constructor {
	if (_index_start < 0) {
		show_error("cannot create drawable with start index less than 0", true);
	}
	if (_index_end >= array_length(_character_array)) {
		show_error("cannot create drawable with end index greater than or equal to length of character array", true);
	}
	
	/// @ignore
	character_array = _character_array;
	/// @ignore
	index_start = _index_start;
	/// @ignore
	index_end = _index_end;
	
	next = self;
	previous = self;
	next = undefined; // helps with typing
	previous = undefined;
	
	style = new StyleableTextStyle();
	sprite = spr_styleable_text_sprite_default;
	
	init_styles = function() {
		if (index_start < array_length(character_array)) {
			style.set_to(character_array[index_start].style);
			sprite = character_array[index_start].sprite;
		}
	};
	
	/// @ignore
	content = "";
	
	/// @ignore
	calculate_content = function() {
		content = "";
		for (var _i = index_start; _i <= index_end; _i++) {
			content += character_array[_i].character;
		}
		init_styles();
	};
	
	calculate_content();
	
	get_content = function() {
		return content;
	};
	
	get_index_start = function() {
		return index_start;
	};
	
	get_index_end = function() {
		return index_end;
	};
	
	/**
	 * @param {real} _new_index_start the new starting index in the character array of this drawable
	 */
	set_index_start = function(_new_index_start) {
		index_start = _new_index_start;
		calculate_content();
	};
	
	/**
	 * @param {real} _new_index_end the new ending index in the character array of this drawable
	 */
	set_index_end = function(_new_index_end) {
		index_end = _new_index_end;
		calculate_content();
	};
	
	/**
	 * Draw this drawables contents and the given position.
	 * @param {real} _x x position
	 * @param {real} _y y position
	 */
	draw = function(_x, _y) {
		/*
		For now we only use default styles, and for that we only
		need the first character referenced, because we can be
		sure this will be the same for all characters in range
		thanks to our merging logic.
		*/
		var _char = character_array[index_start];
		var _draw_x = _x + _char.position_x + style.mod_x;
		var _draw_y = _y + _char.position_y + style.mod_y;
		if (sprite == spr_styleable_text_sprite_default) {
			draw_set_font(style.font);
			draw_set_alpha(style.alpha);
			draw_set_color(style.style_color);
			draw_text_transformed(_draw_x, _draw_y, content, style.scale_x, style.scale_y, style.mod_angle);
		} else {
			draw_sprite_ext(sprite, 0, _draw_x, _draw_y, style.scale_x, style.scale_y, style.mod_angle, style.style_color, style.alpha);
		}
		global.drawables_drawn++;
		init_styles();
	};
}
