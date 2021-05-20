load_some_attack_data()

xdisp = ai_target.x - x
ydisp = ai_target.y - y
xdist = abs(xdisp);
ydist = abs(ydisp);

hold_neutral()

set_plan(get_plan())
do_plan()

// Fastfall aerials
if contains([AT_FAIR, AT_NAIR, AT_BAIR, AT_UAIR, AT_DAIR], attack){
	if (hitpause && is_above_ground()) {
        press_down()
	}
}


#region LEARNING
#define load_some_attack_data
	// ai_thoughts = "updated AI???";
	// if(get_gameplay_time() % 12 == 0) ai_thoughts += ".";
	
	//Limitations:
	//If a character changes their stats, the AI will make inaccurate predictions about them
	
	// exit;
	
	if(currently_learning && learning_phase == "attacks") {
		if(learning_frame == 0) player_ids = [
			noone,
			find_player_instance(1),
			find_player_instance(2),
			find_player_instance(3),
			find_player_instance(4),
			noone
		];
		
		repeat(1) learn();
		
		// if(learning_frame > 15) currently_learning = false;
		learning_frame++; exit;
	} else {
		currently_learning = false
	}
	/*else {
		if(learning_frame != 69) {
			learning_frame = 69;
			// get_string("here you go:", string(known_attacks));
		}
		// ai_thoughts = "help... ;-;";
		ai_thoughts = `player 1's AT_FSTRONG has ${known_attacks[1, AT_FSTRONG].hitboxes_array[4].max_damage} damage`;
	}*/
	

#define find_contacting_hitbox(this_attack, attacker, target, precise)
	if(target.object_index == oPlayer || target.object_index == oTestPlayer) target = target.hurtboxID;
	var fastest_hit = 9999, highest_priority = -1, contacting_hitbox = noone;
	for(var incrementeroo = 0; incrementeroo < this_attack.hitboxes_count; incrementeroo++;) {
		var this_hitbox = this_attack.hitboxes_array[incrementeroo];
		// if(attacker.state_timer > this_hitbox.end_frame) continue;
		
		var is_viable_hit = false, time_until_hit = this_hitbox.frame - attacker.state_timer - 1;
		
		var attacker_projected_pos = get_my_projected_pos(time_until_hit);
		
		// var attacker_projected_pos = get_projected_pos(attacker, time_until_hit, attacker.gravity_speed, attacker.max_fall);
		var hit_x = attacker_projected_pos[0] + this_hitbox.xpos * spr_dir;
		var hit_y = attacker_projected_pos[1] + this_hitbox.ypos;
		var half_w = this_hitbox.radius_x * this_attack.paranoia, half_h = this_hitbox.radius_x * this_attack.paranoia;
		
		
		//If the currently recorded hit has higher priority and is either faster or equal in speed, this one doesn't matter
		if(highest_priority >= this_hitbox.priority && fastest_hit <= time_until_hit) exit;
		
		//If this hitbox's bounding box isn't right, this one doesn't matter
		// var target_half_w = target.sprite_width * 0.5, target_half_h = target.sprite_height * 0.5;
		// if(precise && ((hit_x - half_w < target.x + target_half_w) xor (hit_x + half_w > target.x - target_half_w)))
		// 	continue;
		
		if(this_hitbox.is_rectangle) {
			if(collision_rectangle(hit_x - half_w, hit_y - half_h, hit_x + half_w, hit_y + half_h, target, precise, false)) {
				highest_priority = this_hitbox.priority;
				fastest_hit = time_until_hit;
				contacting_hitbox = this_hitbox;
			}
		}
		else {
			if(collision_ellipse(hit_x - half_w, hit_y - half_h, hit_x + half_w, hit_y + half_h, target, precise, false)) {
				highest_priority = this_hitbox.priority;
				fastest_hit = time_until_hit;
				contacting_hitbox = this_hitbox;
			}
		}
	}
	return(contacting_hitbox);

// #define get_projected_pos(target, time, grav, frict)
// 	return([target.x, target.y]);


#define learn
	if(learning_frame < 1) return(false);
	//First, check if we need to move on and study something else
	switch(learning_phase) {
		case "attacks":
			//Study whatever has been assigned to us this lesson
			ai_thoughts = `Learning all about player ${study_player_num}s ${get_attack_name(study_attack_index)}`; // ERROR: No code injection match found
			comprehend_attack(player_ids[study_player_num], study_attack_index);
			
			//Figure out what we'll study next lesson
			study_attack_index++;
			if(study_attack_index >= 50 || player_ids[study_player_num] == noone) {
				//We're studying the next player's attacks
				study_player_num++;
				study_attack_index = 0;
			}
			if(study_player_num >= 5) {
				//We're studying the first player's options now
				learning_phase = "options"; study_option_type = "jump";
				study_player_num = 1;
			}
		break;
		case "options":
			//Study whatever has been assigned to us this lesson
			ai_thoughts = `Learning all about player ${study_player_num}s ${study_option_type}`; // ERROR: No code injection match found
			switch(study_option_type) {
				case "jump":
					known_options[study_player_num].jump = {
						frame_heights: [],
						peak_height: 0,
						peak_time: 0
					}
					var sim_frame = 0, sim_vsp = -1 * player_ids[study_player_num].jump_speed, sim_y = 0;
					while(sim_vsp < 0 && sim_frame < 60) {
						sim_frame++; sim_vsp += player_ids[study_player_num].gravity;
						sim_y += sim_vsp;
						array_push(known_options[study_player_num].jump.frame_heights, sim_y);
					}
					
					knows_option[study_player_num].jump = true;
				break;
				case "shorthop":
					known_options[study_player_num].shorthop = {
						frame_heights: [],
						peak_height: 0,
						peak_time: 0
					}
					
					knows_option[study_player_num].shorthop = true;
				break;
				case "double_jump":
					known_options[study_player_num].double_jump = {
						frame_heights: [],
						peak_height: 0,
						peak_time: 0
					}
					
					knows_option[study_player_num].double_jump = true;
				break;
				case "wavedash":
					known_options[study_player_num].wavedash = {
						frame_distances: array_create(8, 0),
						initial_hsp: 0,
						duration: 0
					}
					
					knows_option[study_player_num].wavedash = true;
					
					//Figure out what we'll study the next lesson
					study_player_num++; study_option_type = "jump";
					if(study_player_num >= 5 || player_ids[study_player_num] == noone) {
						currently_learning = false; //We're done!
					}
				break;
			}
		break;
		default:
			print(`Invalid learning phase: ${learning_phase}. Something is wrong :(`);
			currently_learning = false;
		break;
	}

#define comprehend_attack(attacker, study_index)
	if(attacker == noone) exit;
	
	// var attack_knowledge = ;
	with(attacker) {
		if(get_attack_value(study_index, AG_NUM_WINDOWS) == 0) {
			//this attack doesn't exist
			other.knows_attack[@attacker.player][@study_index] = undefined;
			exit;
		}
		
		//Prepare basic stuff
		other.known_attacks[@attacker.player][@study_index] = {
			name: get_attack_name(study_index),
			category: get_attack_value(study_index, AG_CATEGORY),
			paranoia: 1.1, //multiplier to the size of predicted hitboxes; doesn't increase naturally yet
			parry_reward_mult: 1.0,
			hitboxes_array: [],
			hitboxes_count: 0,
			max_damage: 0,
			first_active_frame: 0,
			last_active_frame: 0
		};
		
		var windows_count = get_attack_value(study_index, AG_NUM_WINDOWS);
		//Prepare hitboxes array
		var saved_count = 0, valid_count = 0, analyze_hit_index = 1, goal_hit_index = 1 + get_num_hitboxes(study_index);
		while(valid_count < goal_hit_index - 1 && analyze_hit_index <= goal_hit_index + 3) {
			//We assume that if we hit 4 nonexistent hitboxes in a row, the programmer is just a goof who lied about how many hitboxes they have
			if(get_hitbox_value(study_index, analyze_hit_index, HG_HITBOX_TYPE) == 0) {
				//This hitbox doesn't exist
				analyze_hit_index++; continue;
			}
			
			//Hitboxes that have negative window values aren't included
			if(get_hitbox_value(study_index, analyze_hit_index, HG_WINDOW) < 0
			|| get_hitbox_value(study_index, analyze_hit_index, HG_WINDOW) > windows_count) {
				//This hitbox doesn't spawn normally
				analyze_hit_index++; valid_count++; continue;
			}
			
			//Determine the starting frame
			var start_frame = get_hitbox_value(study_index, analyze_hit_index, HG_WINDOW_CREATION_FRAME);
			var process_window = get_hitbox_value(study_index, analyze_hit_index, HG_WINDOW) - 1;
			while(process_window > 0) {
				start_frame += get_window_value(study_index, process_window, AG_WINDOW_LENGTH);
				process_window--;
			}
			
			//Check if it can be charged
			var charge_window = get_attack_value(study_index, AG_STRONG_CHARGE_WINDOW);
			var charge_window_prior = charge_window != 0 && charge_window < get_hitbox_value(study_index, analyze_hit_index, HG_WINDOW);
			
			array_push(other.known_attacks[@attacker.player][@study_index].hitboxes_array, {
				damage: get_hitbox_value(study_index, analyze_hit_index, HG_DAMAGE),
				priority: get_hitbox_value(study_index, analyze_hit_index, HG_PRIORITY),
				is_rectangle: get_hitbox_value(study_index, analyze_hit_index, HG_SHAPE) != 0,
				radius_x: 0.5 * get_hitbox_value(study_index, analyze_hit_index, HG_WIDTH),
				radius_y: 0.5 * get_hitbox_value(study_index, analyze_hit_index, HG_HEIGHT),
				xpos: get_hitbox_value(study_index, analyze_hit_index, HG_HITBOX_X),
				ypos: get_hitbox_value(study_index, analyze_hit_index, HG_HITBOX_Y),
				frame: start_frame,
				end_frame: start_frame + get_hitbox_value(study_index, analyze_hit_index, HG_LIFETIME),
				can_be_charged: charge_window_prior
			});
			
			
			saved_count++; valid_count++; analyze_hit_index++;
		}
		// print(other.known_attacks[attacker.player][study_index].hitboxes_array[1].damage);
		
		//Prepare hitbox-derived details
		other.known_attacks[@attacker.player][@study_index].hitboxes_count = saved_count;
		
	}
	
	knows_attack[@attacker.player][@study_index] = true;

#define get_my_projected_pos(time)
	//Assign friction and gravity
	switch(state) {
		case PS_ATTACK_AIR:
			var frict = "attacking";
			var grav = "attacking";
			
		break;
		case PS_ATTACK_GROUND:
			var frict = "attacking";
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
	
	//Complex friction and gravity
	if(frict == "attacking") {
		if(free) {
			if(get_window_value(attack, window, AG_WINDOW_HSPEED_TYPE) == 1)
				frict = 0;
			else if(get_attack_value(attack, AG_WINDOW_CUSTOM_AIR_FRICTION) != 0)
				frict = get_attack_value(attack, AG_WINDOW_CUSTOM_AIR_FRICTION);
			else
				frict = air_friction;
		}
		else {
			if(get_window_value(attack, window, AG_WINDOW_HSPEED_TYPE) == 1)
				frict = 0;
			else if(get_attack_value(attack, AG_WINDOW_CUSTOM_GROUND_FRICTION) != 0)
				frict = get_attack_value(attack, AG_WINDOW_CUSTOM_GROUND_FRICTION);
			else
				frict = ground_friction;
		}
	}
	if(grav == "attacking") {
		if(get_window_value(attack, window, AG_WINDOW_VSPEED_TYPE) == 1)
			grav = 0;
		else if(get_attack_value(attack, AG_USES_CUSTOM_GRAVITY))
			grav = get_window_value(attack, window, AG_WINDOW_CUSTOM_GRAVITY);
		else
			grav = gravity_speed;
	}
	
	//Simulate movement
	var projected_pos = [x, y], projected_hsp = hsp, projected_vsp = vsp;
	repeat(min(time, 40)) {
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

#endregion

#region PLANNING
#define get_plan()
	// ai_thoughts = "no thoughts head empty :)";
	if currently_learning {
		return p_do_nothing
	}
	ai_thoughts = `player 1s AT_FAIR has ${known_attacks[1, AT_FAIR].hitboxes_array[1].frame} hitboxes`;
	if(player_ids[1].shield_down) get_string("hi?", string(known_attacks[1, AT_FAIR].hitboxes_array));

	var plan = p_do_nothing
	
	var frames_to_impact = 9999
	with(oPlayer) if(get_player_team(player) != get_player_team(other.player)) {
		if((state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND) && other.knows_attack[player][attack]) {
			var contacting_hitbox = find_contacting_hitbox(other.known_attacks[player][attack], id, other, true);
			if(contacting_hitbox != noone) {
				frames_to_impact = contacting_hitbox.frame - state_timer;			
				other.ai_thoughts = `INCOMING IN ${frames_to_impact}!!!`;
			}
		}
	}
	
	if frames_to_impact != 9999{
		prints("frames to impact:", frames_to_impact)	
	}
	
	if(frames_to_impact <= 8) {

		if contacting_hitbox.can_be_charged {
			plan = p_roll_away
		} else {
			plan = p_parry
		}
	}
	return plan

	// with(pHitBox) if(type == 2 && get_player_team(player) != get_player_team(other.player) && sign(hsp) == sign(other.x - x)) {
		//figure out if it's gonna hit me and parry???
		//how do i make that check efficiently
	// }


#define set_plan(new_plan)
	plan = new_plan
	plan_timer = 0	
	
#endregion


#region EXECUTION
#define do_plan()
	// if (plan_timer >= array_length(plan)) print("ERROR: trying to perform completed plan")
	if plan_timer < array_length(plan){
		var actions_for_turn = plan[plan_timer]
		for (var action_i=0; action_i<array_length(actions_for_turn); action_i++) {
		    var action = actions_for_turn[action_i]
		    do_action(action)
		}
	}
	
	plan_timer++

#define do_action(action_name)
	run_if_exists(action_name)

#endregion



#macro AT_NO_ATTACK 0

#define contains(list, value)
    for (var item_i=0; item_i<array_length(list); item_i++) {
        var item = list[item_i]
        if item == value{
            return true
        }
    }
    return false
    
#define is_above_ground() 
	return collision_line(x, y, x, room_height, asset_get("par_block"), 0, 1) > 0;

#region inputs
#define hold_toward_direction(dir)
	if dir < 0 {
		press_left()
	} else {
		press_right()
	}

#define hold_towards_target
	hold_toward_direction(xdisp)

#define hold_away_from_target
	hold_toward_direction(-xdisp)

#define hold_forwards
	hold_toward_direction(spr_dir)

#define hold_backwards
	hold_toward_direction(-spr_dir)

#define hold_neutral
	unpress_left()
	unpress_right()
	unpress_up()
	unpress_down()

#define hold_center_stage
	var center_dir = sign(x - room_width / 2);
	hold_toward_direction(center_dir)

#define tap_current_horizontal_direction
	if left_down {
		tap_left()
	} else if right_down {
		tap_right()
	}

#define unpress_left()
	left_down = false
	left_pressed = false
	left_hard_down = false
	left_hard_pressed = false
	left_strong_down = false
	left_strong_pressed = false

#define unpress_right()
	right_down = false
	right_pressed = false
	right_hard_down = false
	right_hard_pressed = false
	right_strong_down = false
	right_strong_pressed = false

#define unpress_up()
	up_down = false
	up_pressed = false
	up_hard_down = false
	up_hard_pressed = false
	up_strong_down = false
	up_strong_pressed = false

#define unpress_down()
	down_down = false
	down_pressed = false
	down_hard_down = false
	down_hard_pressed = false
	down_strong_down = false
	down_strong_pressed = false
	
#define press_left()
	left_down = true
	left_pressed = true
	unpress_right()	

#define tap_left()
	press_left()
	left_hard_down = true
	left_hard_pressed = true

#define press_right()
	right_down = true
	right_pressed = true
	unpress_left()

#define tap_right()
	press_right()
	right_hard_down = true
	right_hard_pressed = true

#define press_up()
	up_down = true
	up_pressed = true
	unpress_down()
	
#define tap_up()
	press_up()
	up_hard_down = true
	up_hard_pressed = true

#define press_down()
  	down_down = true
  	down_pressed = true
	unpress_up()

#define tap_down
	press_down()
	down_hard_down = true
	down_hard_pressed = true

#define press_no_action_buttons
	attack_down = false
	attack_pressed = false
	special_down = false
	special_pressed = false
	strong_down = false
	strong_pressed = false

#define press_attack()
	press_no_action_buttons()
	attack_down = true
	attack_pressed = true
	
#define press_special()
	press_no_action_buttons()
	special_pressed = true
	special_down = true
	
#define press_strong()
	press_no_action_buttons()
	strong_pressed = true
	strong_down = true

#define press_jump()
	jump_pressed = true
	jump_down = true

#define press_parry()
	shield_pressed = true
	shield_down = true
	parry_pressed = true
	parry_down = true

#define direction_to_target()		
	var direction_to_target = sign(xdisp)
	if direction_to_target == 0 {
		return spr_dir
	} else {
		return direction_to_target
	}
#endregion

#define perform_attack(_attack)
	switch _attack {
		case AT_JAB:	
			press_attack()
		break
		case AT_DATTACK:
			hold_neutral()
			hold_towards_target()
			tap_current_horizontal_direction()
			press_attack()
		break
		case AT_NSPECIAL:
			hold_neutral()
			press_special()
		break
		case AT_FSPECIAL:
		case AT_FSPECIAL_2:
		case AT_FSPECIAL_AIR:
			hold_neutral()
			hold_towards_target();
			press_special()
		break
		case AT_USPECIAL:
			hold_neutral()
			hold_towards_target()
		break
		case AT_DSPECIAL:
		case AT_DSPECIAL_2:
		case AT_DSPECIAL_AIR:
			tap_down()
			hold_towards_target()
			press_special()
		break
		case AT_FSTRONG:
			hold_neutral()
			hold_towards_target()
			press_strong()
		case AT_USTRONG:
			press_up()
			hold_towards_target()
			press_strong()
		break
		case AT_DSTRONG:
			press_down()
			hold_towards_target()
			press_strong()
		break
		case AT_FTILT:
			hold_neutral()
			hold_towards_target()
			press_attack()
		break
		case AT_UTILT:
			press_up()
			hold_towards_target()
			press_attack()
		break
		case AT_DTILT:
			press_down()
			hold_towards_target()
			press_attack()
		break
		case AT_NAIR:
			hold_neutral()
			press_attack()
			if !free { 
				// Todo, if hitbox too low, jump
				jump_down = (y <= ai_target.y - ai_target.char_height); 
				jump_pressed = jump_down
				down_hard_pressed = (y > ai_target.y)
			} 
			break
		case AT_FAIR:
			hold_neutral()
			hold_forwards()
			press_attack()
			if (!free) { jump_down = (y <= ai_target.y - ai_target.char_height); jump_pressed = jump_down; down_hard_pressed = (y > ai_target.y); } 
		break
		case AT_DAIR:
			press_down()
			hold_towards_target()
			press_attack()
			if (!free) { jump_down = (y <= ai_target.y - ai_target.char_height); jump_pressed = jump_down; down_hard_pressed = (y > ai_target.y); } 
		break
		case AT_UAIR:
			press_up()
			hold_towards_target()
			press_attack()
			if (!free) { jump_down = (y <= ai_target.y - ai_target.char_height); jump_pressed = jump_down; down_hard_pressed = (y > ai_target.y); } 
		break
		case AT_BAIR:
			hold_neutral()
			hold_backwards()
			if (!free) { jump_down = (y <= ai_target.y - ai_target.char_height); jump_pressed = jump_down; down_hard_pressed = (y > ai_target.y); } 
			// if (!free) { 
			// 	press_jump() 
			// 	hold_away_from_target()
			// 	epinel_ai_buffer_hold_jump = max(epinel_ai_buffer_hold_jump, 2); 
			// } else {  
			// 	press_attack()
			// 	jump_down = (!free || (y <= ai_target.y - ai_target.char_height)); 
			// 	jump_pressed = jump_down; 
			// 	down_hard_pressed = (y > ai_target.y); 
			// } 
		break
		case AT_TAUNT:
			taunt_down = true;
		break
	}
	
	
	
	
#define get_attack_name(attack)
	switch(attack) {
		case AT_JAB: return("AT_JAB"); break;
		case AT_FTILT: return("AT_FTILT"); break;
		case AT_DTILT: return("AT_DTILT"); break;
		case AT_UTILT: return("AT_UTILT"); break;
		case AT_FSTRONG: return("AT_FSTRONG"); break;
		case AT_DSTRONG: return("AT_DSTRONG"); break;
		case AT_USTRONG: return("AT_USTRONG"); break;
		case AT_DATTACK: return("AT_DATTACK"); break;
		case AT_FAIR: return("AT_FAIR"); break;
		case AT_BAIR: return("AT_BAIR"); break;
		case AT_DAIR: return("AT_DAIR"); break;
		case AT_UAIR: return("AT_UAIR"); break;
		case AT_NAIR: return("AT_NAIR"); break;
		case AT_FSPECIAL: return("AT_FSPECIAL"); break;
		case AT_DSPECIAL: return("AT_DSPECIAL"); break;
		case AT_USPECIAL: return("AT_USPECIAL"); break;
		case AT_NSPECIAL: return("AT_NSPECIAL"); break;
		case AT_TAUNT: return("AT_TAUNT"); break;
		case AT_FSTRONG_2: return("AT_FSTRONG_2"); break;
		case AT_DSTRONG_2: return("AT_DSTRONG_2"); break;
		case AT_USTRONG_2: return("AT_USTRONG_2"); break;
		case AT_FTHROW: return("AT_FTHROW"); break;
		case AT_UTHROW: return("AT_UTHROW"); break;
		case AT_DTHROW: return("AT_DTHROW"); break;
		case AT_NTHROW: return("AT_NTHROW"); break;
		case AT_NSPECIAL_AIR: return("AT_NSPECIAL_AIR"); break;
		case AT_NSPECIAL_2: return("AT_NSPECIAL_2"); break;
		case AT_FSPECIAL_AIR: return("AT_FSPECIAL_AIR"); break;
		case AT_FSPECIAL_2: return("AT_FSPECIAL_2"); break;
		case AT_USPECIAL_GROUND: return("AT_USPECIAL_GROUND"); break;
		case AT_USPECIAL_2: return("AT_USPECIAL_2"); break;
		case AT_DSPECIAL_AIR: return("AT_DSPECIAL_AIR"); break;
		case AT_DSPECIAL_2: return("AT_DSPECIAL_2"); break;
		case AT_TAUNT_2: return("AT_TAUNT_2"); break;
		case AT_EXTRA_1: return("AT_EXTRA_1"); break;
		case AT_EXTRA_2: return("AT_EXTRA_2"); break;
		case AT_EXTRA_3: return("AT_EXTRA_3"); break;
		default:
			if("AT_PHONE" in self && attack == AT_PHONE) return("AT_PHONE");
			return(string(attack));
		break;
	}
	

#define find_player_instance(number)
	with(oPlayer) if(player == number) return(id);
	return(noone);
	
	
	
#define run_if_exists 
    // script_name, ...args
    var script_name = argument[0]
    var num_args = argument_count - 1;
    var args = array_create(num_args);
    for (var i = 0; i < num_args; i++) args[i] = argument[i+1];
    run_if_exists_with_args(script_name, args)

#define run_if_exists_with_args(script_name, args)
    var script_index = script_get_index(script_name)
    if script_index >= 0 {       
        var num_args_to_pass = array_length(args);
        switch(num_args_to_pass) {
            case 0: script_execute(script_index); break;
            case 1: script_execute(script_index, args[0]); break;
            case 2: script_execute(script_index, args[0], args[1]); break;
            case 3: script_execute(script_index, args[0], args[1], args[2]); break;
            default: var crash_var = 1/0 break; // Crash. Add more support for the number of arguments you need.
        }
    }

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