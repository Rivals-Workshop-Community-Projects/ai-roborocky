if(!is_ai) exit;

if(keyboard_lastkey == 84) {
	keyboard_lastkey = 0;
	showing_thoughts = !showing_thoughts;
}
if(!showing_thoughts) exit;

var thinky_x = x + 20, thinky_y = y - 140, thinky_col = ai_thoughts_colour, thinky_alpha = 0.7, text_col = make_colour_hsv(255 - colour_get_hue(thinky_col), colour_get_saturation(thinky_col), 255 - colour_get_value(thinky_col));

draw_sprite_ext(thoughts_bubble, 0, thinky_x + 18, thinky_y + 60, 2, 2, 0, thinky_col, thinky_alpha);
draw_sprite_ext(thoughts_bubble, 1, thinky_x, thinky_y, 2, 2, 0, thinky_col, thinky_alpha);

draw_set_font(asset_get("roaMBLFont")); draw_set_halign(fa_left); draw_set_valign(fa_center); draw_set_colour(text_col);
var thinky_xscale = 1.1, thinky_width = thinky_xscale * string_width(ai_thoughts), represented_thinky_width = 0;
while(represented_thinky_width + 48 < thinky_width) {
	draw_sprite_ext(thoughts_bubble, 2, thinky_x + 58 + represented_thinky_width, thinky_y, 2, 2, 0, thinky_col, thinky_alpha);
	represented_thinky_width += 58;
}

draw_sprite_ext(thoughts_bubble, 3, thinky_x + 58 + represented_thinky_width, thinky_y, 2, 2, 0, thinky_col, thinky_alpha);

draw_text_transformed(thinky_x + 33, thinky_y + 30, ai_thoughts, thinky_xscale, 1.5, 0);