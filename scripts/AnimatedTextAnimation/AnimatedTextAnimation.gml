enum ANIMATED_TEXT_ANIMATIONS {
	FADEIN
}

/**
 * @param {real} _animation_enum_value entry in the ANIMATED_TEXT_ANIMATIONS enum
 * @param {struct.StyleableText} _styleable_text reference to styleable text instance this animation acts on
 * @param {real} _index_start index of first character animation acts on
 * @param {real} _index_end index of last character animation acts on
 * @param {array} _aargs array of parameters for this animation
 */
function AnimatedTextAnimation(_animation_enum_value, _styleable_text, _index_start, _index_end, _aargs) constructor {
	text_reference = _styleable_text;
	index_start = _index_start;
	index_end = _index_end;
	params = _aargs;
	
	/// @param {real} _update_time_ms
	update_merge = function(_update_time_ms) {};
	
	/// @param {real} _update_time_ms
	update_split = function(_update_time_ms) {
		text_reference.split_drawables_at(index_start, index_end);
	};
	
	/// @param {real} _update_time_ms
	update_animate = function(_update_time_ms) {};
	
	animation_finished = false; // finished animations are removed from whatever's using them
	time_ms = 0;
	
	if (_animation_enum_value == ANIMATED_TEXT_ANIMATIONS.FADEIN) {
		duration = 1000;
		
		update_merge = function(_update_time_ms) {
			text_reference.set_characters_hidden(index_start, index_end, false);
			if (time_ms < duration) return;
			animation_finished = true;
			text_reference.merge_drawables_at(index_start, index_end);
		};
		
		/// @param {real} _update_time_ms
		update_animate = function(_update_time_ms) {
			time_ms += _update_time_ms;
			text_reference.set_alpha(index_start, index_end, time_ms/duration);
		};
	}
}

function animated_text_get_empty_array_animation() {
	var _text = new StyleableText("$");
	var _animation = new AnimatedTextAnimation(ANIMATED_TEXT_ANIMATIONS.FADEIN, _text, 0, 0, []);
	return array_create(0, _animation);
}
