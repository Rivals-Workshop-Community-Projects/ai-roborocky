if not "is_ai" in self {
    exit
}

with(oPlayer) if(get_player_team(player) != get_player_team(other.player)) {
	var projected_pos = get_my_projected_pos(16);
	draw_sprite_ext(sprite_index, image_index, projected_pos[0], projected_pos[1], spr_dir, 1, 0, c_lime, get_gameplay_time() % 2 == 0?0.6:0.7);
	
	if(state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND) {
		for(var incrementeroo = 0; incrementeroo < other.known_attacks[player][attack].hitboxes_count; incrementeroo++;) {
			var this_hitbox = other.known_attacks[player][attack].hitboxes_array[incrementeroo], this_attack = other.known_attacks[player][attack];
			
			var time_until_hit = this_hitbox.frame - state_timer;
			if(time_until_hit < 0) continue;
			
			var attacker_projected_pos = get_my_projected_pos(time_until_hit);
			
			var hit_x = attacker_projected_pos[0] + this_hitbox.xpos * spr_dir;
			var hit_y = attacker_projected_pos[1] + this_hitbox.ypos;
			var half_w = this_hitbox.radius_x * this_attack.paranoia, half_h = this_hitbox.radius_y * this_attack.paranoia;
			
			draw_set_alpha(clamp(1 - (time_until_hit / 5), 0.43, 1.0));
			if(this_hitbox.is_rectangle)
				draw_rectangle_colour(hit_x - half_w, hit_y - half_h, hit_x + half_w, hit_y + half_h, c_red, $ee9bff, c_red, $ee9bff, false); // ERROR: No code injection match found // ERROR: No code injection match found // ERROR: No code injection match found
			else
				draw_ellipse_colour(hit_x - half_w, hit_y - half_h, hit_x + half_w, hit_y + half_h, c_red, $ee9bff, false);
			draw_set_alpha(1.0);
		}
	}
}

#define get_my_projected_pos(time)
	switch(state) {
		case PS_ATTACK_AIR:
			var frict = get_my_friction();
			var grav = get_my_gravity();
			
		break;
		case PS_ATTACK_GROUND:
			var frict = get_my_friction();
			var grav = 0;
		break;
		case PS_HITSTUN:
			var frict = air_friction;
			var grav = hitstun_grav;
		break;
		case PS_WAVELAND:
			var frict = wave_friction;
			var grav = 0;
			var remaining_waveland = wave_land_time - state_timer;
		break;
		case PS_WALK: case PS_DASH: case PS_DASH_START:
			var frict = 0, grav = 0;
		break;
		case PS_JUMPSQUAT:
			var frict = ground_friction, grav = 0;
		break;
		default:
			var frict = free?air_friction:ground_friction;
			var grav = free?gravity_speed:0;
		break;
	}
	var projected_pos = [x, y], projected_hsp = hsp, projected_vsp = vsp;
	repeat(time) {
		if(state == PS_WAVELAND) {
			remaining_waveland--;
			if(remaining_waveland <= 0) return(projected_pos);
		}
		if(place_meeting(projected_pos[0], projected_pos[1], asset_get("par_block"))) projected_vsp = 0;
		projected_pos[0] += projected_hsp;
		projected_pos[1] += projected_vsp;
		projected_hsp -= sign(projected_hsp) * frict;
		if(projected_vsp < max_fall) projected_vsp += grav;
	} 
	return(projected_pos);

#define get_my_friction
	if(free) {
		if(get_window_value(attack, window, AG_WINDOW_HSPEED_TYPE) == 1)
			return(0);
		if(get_attack_value(attack, AG_WINDOW_CUSTOM_AIR_FRICTION) != 0)
			return(get_attack_value(attack, AG_WINDOW_CUSTOM_AIR_FRICTION));
		return(air_friction);
	}
	else {
		if(get_window_value(attack, window, AG_WINDOW_HSPEED_TYPE) == 1)
			return(0);
		if(get_attack_value(attack, AG_WINDOW_CUSTOM_GROUND_FRICTION) != 0)
			return(get_attack_value(attack, AG_WINDOW_CUSTOM_GROUND_FRICTION));
		return(ground_friction);
	}

#define get_my_gravity
	if(get_window_value(attack, window, AG_WINDOW_VSPEED_TYPE) == 1)
		return(0);
	if(get_attack_value(attack, AG_USES_CUSTOM_GRAVITY))
		return(get_window_value(attack, window, AG_WINDOW_CUSTOM_GRAVITY));
	return(gravity_speed);