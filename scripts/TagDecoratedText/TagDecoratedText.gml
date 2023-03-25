/**
 * @param {string} _source_string the string with decorative tags
 */
function TagDecoratedText(_source_string) constructor {
	/*
	The source string contains both the tags and the text to actually display. From
	this we need to build an array of commands and their index ranges as well as 
	the text to display with command tags removed.
	*/
	
	commands = [];	
	
	displayed_text = "";
	
	var _index = 1;
	
	for (var _i = 1; _i <= string_length(_source_string); _i++) {
		var _c = string_char_at(_source_string, _i);
		var _c_next = string_char_at(_source_string, _i + 1);
		
		// handle command
		if (_c == "<" && _c_next != ">" && _c_next != "") {
			var _end_index = string_pos_ext(">", _source_string, _i + 1);
			var _command = string_copy(_source_string, _i + 1, _end_index - _i - 1);
			array_push(commands, new TagDecoratedTextCommand(_command, _index));
			_i = _end_index;
		}
		
		// handle clear tag
		if (_c == "<" && _c_next == ">") {
			// set end of all commands without end set
			for (var _k = array_length(commands) - 1; _k >= 0; _k --) {
				if (commands[_k].index_end < 0) {
					commands[_k].index_end = _index - 1;
				} else {
					_k = -1; // end loop if index_end defined
				}
			}
			_i++;
		}
		
		// handle error
		if (_c == "<" && _c_next == "") {
			show_error("Improper tags used in tag decorated text!", true);
		}
		
		// handle regular text
		if (_c != "<") {
			displayed_text += _c;
			_index++;
		}
	}
}

/**
 * @ignore
 * @param {string} _command
 * @param {real} _index_start
 */
function TagDecoratedTextCommand(_command, _index_start) constructor {
	command = _command;
	index_start = _index_start;
	index_end = -1;
}
