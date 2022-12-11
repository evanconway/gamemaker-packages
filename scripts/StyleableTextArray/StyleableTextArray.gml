/**
 * Creates an easily styleable array of text.
 * @param {string} _source the string to build the array from
 * @param {real} _width max width of text before line breaks occur
 */
function StyleableTextArray(_source, _width = 600) constructor {
	character_array = array_create(string_length(_source), new StyleableTextCharacter("$"));
	for (var _i = 1; _i <= string_length(_source); _i++) {
		character_array[_i - 1] = new StyleableTextCharacter(string_char_at(_source, _i));
	}
	
	width = _width;
	
	/**
	 * Sets the line index for characters in the given range.
	 * @param {real} _index_start start index 
	 * @param {real} _index_end end index
	 * @param {real} _line_index the line index to give the characters
	 */
	characters_set_line_index = function(_index_start, _index_end, _line_index) {
		for (var _i = _index_start; _i <= _index_end; _i ++) {
			character_array[_i].line_index = _line_index;
		}
	};
	
	calculate_xy = function() {
		// first pass: determine line breaks using line_index
		var _line_index = 0;
		var _line_width = 0;
		var _word_index_start = 0;
		var _word_index_end = -1; // -1 if word has not started
		var _word_width = 0;
		
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			
			// if space, word is finished
			if (_char.character == " ") {
				// if word is too big for line, start new line
				if (_line_width + _word_width > width) {
					_line_index++;
					_line_width = 0;
				}
				
				// add word to current line
				characters_set_line_index(_word_index_start, _word_index_end, _line_index);
				_line_width += _word_width;
				_word_width = 0;
				_word_index_end = -1; // mark word as not started
				
				// add space to current line
				characters_set_line_index(_i, _i, _line_index);
				_line_width += _char.get_width();
				
			// otherwise add to current word
			} else {
				// start new word if one has not been started
				if (_word_index_end < 0) _word_index_start = _i;
				_word_width += _char.get_width();
				_word_index_end = _i;
			}
		}
		
		// set last word line index
		if (_word_index_end <= 0) {
			// if word is too big for line, start new line
			if (_line_width + _word_width > width) {
				_line_index++;
				_line_width = 0;
			}
			
			// add word to current line
			characters_set_line_index(_word_index_start, _word_index_end, _line_index);
			_line_width += _word_width;
			_word_width = 0;
			_word_index_end = -1; // mark word as not started
		}
		
		// second pass: determine line heights
		var _line_heights = ds_map_create();
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			if (!ds_map_exists(_line_heights, _char.line_index)) {
				ds_map_set(_line_heights, _char.line_index, _char.get_height());
			} else {
				if (ds_map_find_value(_line_heights, _char.line_index) < _char.get_height()) {
					ds_map_set(_line_heights, _char.line_index, _char.get_height());
				}
			}
		}
		
		// third pass: set xy positions
		var _x = 0;
		var _y = 0;
		var _current_line_index = character_array[0].line_index;
		for (var _i = 0; _i < array_length(character_array); _i++) {
			var _char = character_array[_i];
			if (_char.line_index != _current_line_index) {
				_x = 0;
				_y += ds_map_find_value(_line_heights, _current_line_index);
				_current_line_index = _char.line_index;
			}
			_char.position_x = _x;
			_x += _char.get_width();
			_char.position_y = _y;
		}
	};
	
	calculate_xy();
	
	/**
	 * Draw this StyleableTextArray instance at the given x and y positions.
	 * @param {real} _x x position
	 * @param {real} _y y position
	 */
	draw = function(_x, _y) {
		for (var _i = 0; _i < array_length(character_array); _i++) {
			character_array[_i].draw(_x, _y);
		}
	};
}