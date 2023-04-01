/**
 * Create a conversation instance from the given dialog file name.
 *
 * @param {string} _dialog_file_name
 * @param {real} _width
 * @param {real} _height
 */
function Conversation(_dialog_file_name, _width, _height) constructor {
	dialog = new Dialog(_dialog_file_name);
	width = _width;
	height = _height;
	
	language = "eng";
	
	// set when changing steps
	current_step_tag_decorated_text = new TagDecoratedText("$");
	current_step_options_menu = new TextMenu([]);
	
	text_effects_default = "";
	option_effects_default = "";
	option_effects_highlighted = "";
	option_effects_selected = "";
}

/**
 * @param {Struct.Conversation} _conversation
 * @param {string} _step_name
 */
function conversation_start(_conversation, _step_name) {
	var _step_name_valid = dialog_set_step(_conversation.dialog, _step_name);
	if (!_step_name_valid) return;
	
	with (_conversation) {
		current_step_tag_decorated_text = new TagDecoratedText(dialog_get_text(dialog, language), text_effects_default, width, height);
		var _options = dialog_get_options(dialog);
		if (array_length(_options) > 0) {
			current_step_options_menu = new TextMenu(_options, option_effects_default, option_effects_highlighted, option_effects_selected);
			// setup menu callbacks
			var _f = function(_option_index_selected) {
				dialog_choose_option(dialog, _option_index_selected);
			};
			text_menu_set_on_option_selected_animation_finished(current_step_options_menu, _f);
		}
	}
}

/**
 * @param {Struct.Conversation} _conversation
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 * @param {real} _update_time_ms
 */
function conversation_update(_conversation, _x, _y, _alignment =fa_left, _update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	with (_conversation) {
		if (!dialog_get_is_active(dialog)) return;
		
		var _current_step_name = dialog_get_current_step_name(dialog);
		
		// handle input
		if (array_length(dialog_get_options(dialog)) > 0) {
			text_menu_update(current_step_options_menu, _x, _y, _alignment);
		}
		
		// if 
		
		// set conversation elements if step has changed
		if (dialog_get_current_step_name(dialog) != _current_step_name) {
			current_step_tag_decorated_text = new TagDecoratedText(dialog_get_text(dialog, language))
		}
		
		tag_decorated_text_update(current_step_tag_decorated_text, _update_time_ms);
	}
}

/**
 * @param {Struct.Conversation} _conversation
 * @param {real} _x
 * @param {real} _y
 */
function conversation_draw(_conversation, _x, _y, _alignment = fa_left) {
	with (_conversation) {
		if (!dialog_get_is_active(dialog)) return;
		tag_decorated_text_draw_no_update(current_step_tag_decorated_text, _x, _y, _alignment);
		if (array_length(dialog_get_options(dialog)) > 0) {
			text_menu_draw_no_update(current_step_options_menu, _x, _y, _alignment)
		}
	}
}

/**
 * @param {Struct.Conversation} _conversation
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 * @param {real} _update_time_ms
 */
function conversation_update_and_draw(_conversation, _x, _y, _alignment = fa_left, _update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	conversation_update(_conversation, _x, _y, _alignment, _update_time_ms);
	conversation_draw(_conversation, _x, _y, _alignment);
}