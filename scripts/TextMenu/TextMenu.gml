/**
 * Create a new TextMenu.
 * @param {array<string>} _options
 * @param {string} _default_effects
 * @param {string} _highlight_effects
 * @param {string} _selected_effects
 */
function TextMenu(_options, _default_effects = "gray", _highlight_effects = "yellow fade", _selected_effects = "lime") constructor{
	list = new TextButtonList(_options, _default_effects, _highlight_effects, _selected_effects);
	get_mouse_x = function() {
		return window_mouse_get_x();
	};
	
	get_mouse_y = function() {
		return window_mouse_get_y();
	};
	mx = get_mouse_x();
	my = get_mouse_y();
	using_mouse = false;
	
	
	
	selected_time = -1;
	
	selected_time = -1;
}

function text_menu_update() {
	
}
