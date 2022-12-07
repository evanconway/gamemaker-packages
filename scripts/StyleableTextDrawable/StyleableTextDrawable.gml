/**
 * Get a new StyleableTextDrawable instance.
 * @param {array<struct.StyleableTextCharacter>} _character_array reference to a StyleableTextCharacter array
 * @param {real} _index_start index of first character this drawable references, inclusive
 * @param {real} _index_end index of last character this drawable references, inclusive
 */
function StyleableTextDrawable(_character_array, _index_start, _index_end) constructor {
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
	
	/// @ignore
	content = "";
	
	/// @ignore
	calculate_content = function() {
		content = "";
		for (var _i = index_start; _i <= index_end; _i++) {
			content += character_array[_i].character;
		}
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
		var _style = _char.style;
		var _sprite = _char.sprite;
		var _draw_x = _x + _style.mod_x + _char.position_x;
		var _draw_y = _y + _style.mod_y + _char.position_y;
		if (_char.sprite == spr_styleable_text_sprite_default) {
			draw_set_font(_style.font);
			draw_set_alpha(_style.alpha);
			draw_set_color(_style.style_color);
			draw_text_transformed(_draw_x, _draw_y, content, _style.scale_x, _style.scale_y, _style.mod_angle);
		} else {
			draw_sprite_ext(_char.sprite, 0, _draw_x, _draw_y, _style.scale_x, _style.scale_y, _style.mod_angle, _style.style_color, _style.alpha);
		}
	};
}
