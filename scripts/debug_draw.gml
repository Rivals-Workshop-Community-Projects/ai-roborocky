// prints(known_attacks)

// with(oPlayer) if(get_player_team(player) != get_player_team(other.player)) {
// 	if(state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND) {
// 		for(var incrementeroo = 0; incrementeroo < other.known_attacks[player][attack].hitboxes_count; incrementeroo++;) {
// 			var this_hitbox = other.known_attacks[player][attack].hitboxes_array[incrementeroo];
			
// 			var time_until_hit = this_hitbox.frame - state_timer;
			
// 			var attacker_projected_pos = get_my_projected_pos(time_until_hit);
			
// 			var hit_x = x + time_until_hit * hsp + this_hitbox.xpos * spr_dir;
// 			var hit_y = y + time_until_hit * vsp + this_hitbox.ypos;
// 			var half_w = this_hitbox.width / 2 * 1.15, half_h = this_hitbox.height / 2 * 1.15;
			
// 			if(this_hitbox.is_rectangle)
// 				draw_rectangle_colour(hit_x - half_w, hit_y - half_h, hit_x + half_w, hit_y + half_h, $ee9bff, $ee9bff, $ee9bff, $ee9bff, false);
// 			else
// 				draw_ellipse_colour(hit_x - half_w, hit_y - half_h, hit_x + half_w, hit_y + half_h, $ee9bff, $ee9bff, false); // ERROR: No code injection match found // ERROR: No code injection match found // ERROR: No code injection match found // ERROR: No code injection match found // ERROR: No code injection match found // ERROR: No code injection match found
// 		}
// 	}
// }

// #define get_my_projected_pos(time)
// 	switch(state) {
// 		case PS_ATTACK_AIR:
// 			var frict = get_my_friction();
// 			var grav = get_my_gravity();
			
// 		break;
// 		case PS_ATTACK_GROUND:
// 			var frict = get_my_friction();
// 			var grav = 0;
// 		break;
// 		case PS_HITSTUN:
// 			var frict = air_friction;
// 		break;
// 	}
// 	return([x, y]);

// #define get_my_friction
// 	if(free) {
// 		if(get_window_value(attack, window, AG_WINDOW_HSPEED_TYPE) == 1)
// 			return(0);
// 		if(get_attack_value(attack, AG_WINDOW_CUSTOM_AIR_FRICTION) != 0)
// 			return(get_attack_value(attack, AG_WINDOW_CUSTOM_AIR_FRICTION));
// 		return(air_friction);
// 	}
// 	else {
// 		if(get_window_value(attack, window, AG_WINDOW_HSPEED_TYPE) == 1)
// 			return(0);
// 		if(get_attack_value(attack, AG_WINDOW_CUSTOM_GROUND_FRICTION) != 0)
// 			return(get_attack_value(attack, AG_WINDOW_CUSTOM_GROUND_FRICTION));
// 		return(ground_friction);
// 	}

// #define get_my_gravity
// 	if(get_window_value(attack, window, AG_WINDOW_VSPEED_TYPE) == 1)
// 		return(0);
// 	if(get_attack_value(attack, AG_USES_CUSTOM_GRAVITY))
// 		return(get_window_value(attack, window, AG_WINDOW_CUSTOM_GRAVITY));
// 	return(gravity_speed);

//

// vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define prints // Version 0
    // Prints each parameter to console, separated by spaces.
    var _out_string = string(argument[0])
    for (var i=1; i<argument_count; i++) {
        _out_string += " "
        _out_string += string(argument[i])
    }
    print(_out_string)
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!