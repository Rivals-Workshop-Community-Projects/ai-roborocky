if (my_hitboxID.attack == AT_DSPECIAL && my_hitboxID.hbox_num == 1){
    state = PS_PRATFALL;
}


star__got_parried()

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define star__got_parried // Version 0
        with (pHitBox){
        if (player == other.player){
            if (attack == AT_DSPECIAL && hbox_num == 2 && hsp == 0){
                player_id.star_cooldown = player_id.star_cooldown_time;
                destroyed = true;
            }
        }
    }
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion