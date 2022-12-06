/**
 * Create a new Tag Decorated Text Drawable element. Requires a reference to a
 * Tag Decorated String Character array. Although a single drawable can draw
 * many characters from the array, it needs to start with a reference to a
 * single character. The drawable does not modify the character array it
 * references.
 * @param {array<struct.TagDecoratedTextCharacter>} _character_arr the character array this drawable derives its data from
 * @param {real} _index the index in the character array
 */
function TagDecoratedTextDrawable(_character_arr, _index) constructor {
	character_array_reference = _character_arr; // this array is never modified
	
	// set links to self to trigger feather typing, but the immediately unset
	previous = self;
	next = self;
	previous = undefined;
	next = undefined;
	
	i_start = _index;
	i_end = _index;
	content = "";
	content_width = 0;
	content_height = 0;
	style = character_array_reference[i_start].style.copy();
	animations = tag_decorated_text_get_empty_array_animations();
	for (var _i = 0; _i < array_length(character_array_reference[i_start].animations); _i++) {
		array_push(animations, character_array_reference[i_start].animations[_i].copy());
	}
	animation_hash = "";
	
	sprite = function() {
		/*
		Drawables are designed to be unmergeable if any of its characters contain sprites.
		So we know that all drawables only refer to one index if they contain a sprite. So
		we can just use i_start here.
		*/
		return character_array_reference[i_start].sprite;
	};
	
	/**
	 * Calculates the content, sprite, and content widths and heights for
	 * this drawable and its animations. Modifies this drawable and its
	 * animations.
	 */
	calculate_content = function() {
		content = "";		
		var _content_width = 0;
		var _content_height = 0;
		if (sprite() == undefined) {
			for (var _i = i_start; _i <= i_end; _i++) {
				content += character_array_reference[_i].character;
				_content_width += character_array_reference[_i].char_width;
				if (character_array_reference[_i].char_height > _content_height) {
					_content_height = character_array_reference[_i].char_height;
				}
			}
		} else {
			_content_width = sprite_get_width(sprite()) * style.scale_x;
			_content_height = sprite_get_height(sprite()) * style.scale_y;
		}
		
		animation_hash = "";
		for (var _i = 0; _i < array_length(animations); _i++) {
			animations[_i].content_width = _content_width;
			animations[_i].content_height = _content_height;
			animation_hash += string(animations[_i].get_hash());
		}
	};
	calculate_content();
	
	/**
	 * Returns a boolean indicating if this drawable can be merged with others.
	 * based on its sprite status and animations.
	 */
	get_mergeable = function() {
		if (sprite() != undefined) return false;
		var _result = true;
		for (var _i = 0; _i < array_length(animations); _i++) {
			var _animation_mergeable = animations[_i].mergeable;
			if (!_animation_mergeable) {
				_result = false;
				_i = array_length(animations);
			}
		}
		return _result;
	};
	
	/**
	 * Merges this drawable with the previous and next drawables it references. The 
	 * previous and next drawables are destroyed. Drawables are only merged
	 * if mergeable. Returns a boolean indicating if a merge occurred.
	 *
	 * We have to redo this. Instead this drawable is destroyed and all content is 
	 * is merge to the left.
	 */
	merge = function() {
		if (!get_mergeable()) return;
		
		// merge previous with this
		if (
			previous != undefined && 
			previous.i_end + 1 == i_start && 
			previous.get_mergeable() && 
			previous.animation_hash == animation_hash && 
			character_array_reference[previous.i_start].line_index == character_array_reference[i_start].line_index
		) {
			previous.i_end = i_end;
			previous.next = next;
			
			// merge previous with next
			if (next != undefined && 
				previous.i_end + 1 == next.i_start &&
				next.get_mergeable() &&
				previous.animation_hash == next.animation_hash &&
				character_array_reference[previous.i_start].line_index == character_array_reference[next.i_start].line_index
			) {
				previous.i_end = next.i_end;
				previous.next = next.next;
			}
			
			previous.calculate_content();
		// merge this with next
		} else if (
			next != undefined &&
			i_end + 1 == next.i_start &&
			next.get_mergeable() &&
			animation_hash == next.animation_hash &&
			character_array_reference[i_start].line_index == character_array_reference[next.i_start].line_index
		) {
			i_end = next.i_end;
			next = next.next;
			calculate_content();
		}
	};
	
	/**
	 * Resets any style modifications to the style stored in the character array.
	 */
	init = function() {
		var _style = character_array_reference[i_start].style;
		style.font = _style.font;
		style.style_color = _style.style_color;
		style.alpha = _style.alpha;
		style.scale_x = _style.scale_x;
		style.scale_y = _style.scale_y;
		style.mod_x = _style.mod_x;
		style.mod_y = _style.mod_y;
		style.mod_angle = _style.mod_angle;
	};
	
	/**
	 * Update all animations in this drawable 
	 * @param {real} _time_ms time in ms that has passed in the game
	 */
	update = function(_time_ms) {
		init();
		for (var _i = 0; _i < array_length(animations); _i++) {
			var _animation = animations[_i];
			_animation.update(_time_ms);
			var _s = _animation.style;
			if (_s.mod_angle != undefined) {
				style.mod_angle += _s.mod_angle;
			}
			if (_s.style_color != undefined) {
				style.style_color = _s.style_color;
			}
			if (_s.font != undefined) {
				style.font = _s.font;
			}
			if (_s.alpha != undefined) {
				style.alpha *= _s.alpha;
			}
			if (_s.mod_x != undefined) {
				style.mod_x += _s.mod_x;
			}
			if (_s.mod_y != undefined) {
				style.mod_y += _s.mod_y;
			}
			if (_s.scale_x != undefined) {
				style.scale_x *= _s.scale_x;
			}
			if (_s.scale_y != undefined) {
				style.scale_y *= _s.scale_y;
			}
		}
	};
	
	/**
	 * Draw this drawable at the given x y position.
	 * @param {real} _x x position
	 * @param {real} _y y position
	 */
	draw = function(_x, _y) {
		draw_set_font(style.font);
		draw_set_color(style.style_color);
		draw_set_alpha(style.alpha);
		var _char_x = character_array_reference[i_start].char_x;
		var _char_y = character_array_reference[i_start].char_y;
		var _char_style_mod_x = character_array_reference[i_start].style.mod_x;
		var _char_style_mod_y = character_array_reference[i_start].style.mod_y;
		var _draw_x = _x + _char_x + _char_style_mod_x + style.mod_x;
		var _draw_y = _y + _char_y + _char_style_mod_y + style.mod_y;
		if (sprite() == undefined) {
			draw_text_transformed(_draw_x, _draw_y, content, style.scale_x, style.scale_y, style.mod_angle);
		} else {
			draw_sprite_ext(sprite(), 0, _draw_x, _draw_y, style.scale_x, style.scale_y, style.mod_angle, style.style_color, style.alpha);
		}
	};
}

/**
 * Get an undefined value that feather recognizes as type drawable.
 */
function tag_decorated_text_get_undefined_drawable() {
	var _charracter_array = array_create(1, new TagDecoratedTextCharacter("$", new TagDecoratedTextStyle(), tag_decorated_text_get_empty_array_animations(), 0));
	var _result = new TagDecoratedTextDrawable(_charracter_array, 0);
	_result = undefined;
	return _result;
}