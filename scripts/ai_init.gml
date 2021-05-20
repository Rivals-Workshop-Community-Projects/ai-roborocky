// far_down_attacks[0] = AT_DAIR;

// far_side_attacks[0] = AT_NSPECIAL;
// far_side_attacks[1] = AT_FSPECIAL;

// mid_side_attacks[0] = AT_FSTRONG;
// mid_side_attacks[1] = AT_DATTACK;
// mid_side_attacks[2] = AT_FSPECIAL;
// mid_side_attacks[3] = AT_FTILT;

// close_up_attacks[0] = AT_USTRONG;
// close_up_attacks[1] = AT_UAIR;
// close_up_attacks[2] = AT_UTILT;

// close_down_attacks[0] = AT_DSTRONG;
// close_down_attacks[1] = AT_DAIR;
// close_down_attacks[2] = AT_DTILT;

// close_side_attacks[0] = AT_FSTRONG;
// close_side_attacks[1] = AT_FAIR;
// close_side_attacks[2] = AT_FTILT;

// neutral_attacks[0] = AT_JAB;
// neutral_attacks[1] = AT_NAIR;
// neutral_attacks[2] = AT_DSPECIAL;



#region Floral learning

learning_frame = 0; allowed_learning_time = 125;
currently_learning = true;

learning_phase = "attacks";
study_player_num = 1;
study_attack_index = 0;
study_option_type = "jump";

viable_attack_indexes = 49;

knows_attack = array_create(5, undefined);
for(var incrementeroo = 1; incrementeroo < 5; incrementeroo++;) knows_attack[incrementeroo] = array_create(50, false);
known_attacks = array_create(5, undefined);
for(var incrementeroo = 1; incrementeroo < 5; incrementeroo++;) known_attacks[incrementeroo] = array_create(50, undefined);



knows_option = array_create(5, undefined);
for(var incrementeroo = 1; incrementeroo < 5; incrementeroo++;) knows_option[incrementeroo] = {
	jump: false,
	shorthop: false,
	double_jump: false,
	wavedash: false
};
known_options = array_create(5, undefined);
for(var incrementeroo = 1; incrementeroo < 5; incrementeroo++;) known_options[incrementeroo] = {
	jump: undefined,
	shorthop: undefined,
	double_jump: undefined,
	wavedash: undefined
};


example_options = {
	known_gravity: 0,
	known_jump_speed: 0,
	jump_height_frames: [],
	jump_peak: 0,
	shorthop_height_frames: [],
	shorthop_peak: 0,
};

#endregion




#region PLANS

p_do_nothing = [[]]

p_parry = [
	["hold_neutral", "press_parry"],
	[],	[],	[],
	[],	[],	[],
	[],
	["press_jump"],
]
#endregion

plan_timer = 0
plan = p_do_nothing