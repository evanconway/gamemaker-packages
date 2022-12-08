function AnimatedText(_source_string) constructor {
	text = new StyleableText(_source_string);
	
	get_character_count = function() {
		return array_length(text.character_array);
	};
	
	animations = [];
	
/**
 * @func add_animation(_animation_enum_value, _index_start, _index_end, _aargs)
 * @param {real} _animation_enum_value entry in the ANIMATED_TEXT_ANIMATIONS enum
 * @param {real} _index_start index of first character animation acts on
 * @param {real} _index_end index of last character animation acts on
 * @param {array} _aargs array of parameters for this animation
 */
	add_animation = function(_animation_enum_value, _index_start, _index_end, _aargs) {
		array_push(animations, new AnimatedTextAnimation(_animation_enum_value, text, _index_start, _index_end, _aargs));
	}
	
	/**
	 * @param 
	 */
	update = function(_update_time_ms) {
		for (var _i = 0; _i < array_length(animations); _i++) {
			animations[_i].update_merge(_update_time_ms);
		}
		
		animations = array_filter(animations, function(_a) {
			return !_a.animation_finished;
		});
		
		for (var _i = 0; _i < array_length(animations); _i++) {
			animations[_i].update_split(_update_time_ms);
		}
		for (var _i = 0; _i < array_length(animations); _i++) {
			animations[_i].update_animate(_update_time_ms);
		}
	};
	
	/**
	 * @param {real} _x
	 * @param {real} _y
	 */
	draw = function(_x, _y) {
		update(1000 / game_get_speed(gamespeed_fps));
		text.draw(_x, _y);
	};
}
