extends Enemy

func _physics_process(delta):
	_prep_character_for_update(delta)
	_update_states(delta)
	_update_bb_states(delta)
	_move(delta)
	
func _update_bb_states(delta: float)->void:
	if !activated:
		if dist_to_player() <= activation_distance: activated = true
		else: return
	
	## AI HERE ##
	if life > 0:
		if player_is_to_right(): $Flipper.scale.x = -default_scale
		else: $Flipper.scale.x = default_scale

	if !AP: return
#	if anim_lock and AP.is_playing(): return
	var new_anim := anim
	
	if life <= 0: new_anim = "death"
	elif stun_clock: new_anim = "hurt"
	elif !is_on_floor(): new_anim = "air"
	elif taking_input and (in_left or in_right):
		if guarding: new_anim = "guard_walk"
		else: new_anim = "walk"
	elif guarding: new_anim = "guard"
	elif in_attack:
		if $Flipper.scale.x < 0: new_anim = "attack_backhand"
		else: new_anim = "attack_fronthand"
	else: new_anim = "stand"
	
	if anim != new_anim:
		anim = new_anim
		AP.play(anim, .15)
