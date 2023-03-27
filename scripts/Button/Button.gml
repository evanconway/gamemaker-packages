/**
 * @param {string} _string
 * @param {string} _default_effects
 * @param {string} _highlight_effects
 */
function TextButton(_string, _default_effects = "", _highlight_effects = "yellow fade", _selected_effects = "blink:0.6,1,50") constructor {
	tds = new TagDecoratedText(_string, _default_effects);
	tds_highlighted = new TagDecoratedText(_string, _highlight_effects);
	tds_selected = new TagDecoratedText(_string, _selected_effects);
	
	/**
	 * Reset animation state of default effects.
	 */
	reset_animations_default = function() {		
		tag_decorated_text_reset_animations(tds);
	};
	
	/**
	 * Reset animation state of highlighted effects.
	 */
	reset_animations_highlighted = function() {
		tag_decorated_text_reset_animations(tds_highlighted);
	};
	
	/**
	 * Reset animation state of selected effects.
	 */
	reset_animations_selected = function() {
		tag_decorated_text_reset_animations(tds_selected);
	}
	
	reset_animations = function() {
		tag_decorated_text_reset_animations(tds);
		tag_decorated_text_reset_animations(tds_highlighted);
		tag_decorated_text_reset_animations(tds_selected);
	}
	
	/**
	 * @param {real} _button_x
	 * @param {real} _button_y
	 * @param {real} _point_x
	 * @param {real} _point_y
	 */
	is_point_on = function(_button_x, _button_y, _point_x, _point_y) {
		var _far_x = _button_x + tag_decorated_text_get_width(tds);
		var _far_y = _button_y + tag_decorated_text_get_height(tds);
		return _point_x >= _button_x && _point_x <= _far_x && _point_y >= _button_y && _point_y <= _far_y;
	};
	
	/**
	 * @param {real} _x
	 * @param {real} _y
	 * @param {bool} _highlighted
	 */
	draw = function(_x, _y, _highlighted = false, _selected = false) {
		// offsets to account for different size of highlight and selected
		if (_selected) {
			var _offset_x = floor((tag_decorated_text_get_width(tds) - tag_decorated_text_get_width(tds_selected)) / 2);
			var _offset_y = floor((tag_decorated_text_get_height(tds) - tag_decorated_text_get_height(tds_selected)) / 2);
			tag_decorated_text_draw(tds_selected, _x + _offset_x, _y + _offset_y);
			return
		}
		if (_highlighted) {
			var _offset_x = floor((tag_decorated_text_get_width(tds) - tag_decorated_text_get_width(tds_highlighted)) / 2);
			var _offset_y = floor((tag_decorated_text_get_height(tds) - tag_decorated_text_get_height(tds_highlighted)) / 2);
			tag_decorated_text_draw(tds_highlighted, _x + _offset_x, _y + _offset_y);
			return
		}
		tag_decorated_text_draw(tds, _x, _y);
	};
}
