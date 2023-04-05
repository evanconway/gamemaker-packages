draw_self();
draw_set_color(c_lime);
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
draw_set_color(c_red);
draw_point(bbox_left, bbox_top);
draw_point(bbox_left, bbox_bottom - 1);
draw_point(bbox_right - 1, bbox_top);
draw_point(bbox_right - 1, bbox_bottom - 1);