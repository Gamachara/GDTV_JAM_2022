extends Enemy

func _physics_process(delta):
	_prep_character_for_update(delta)
	_update_states(delta)
	_update_eyeguy_states(delta)
	_move(delta)
	
func _update_eyeguy_states(delta: float)->void:
	if !activated:
		if dist_to_player() <= activation_distance: activated = true
		else: return
	
	## AI HERE ##
	
	
	if life > 0:
		if player_is_to_right(): $Flipper.scale.x = -default_scale
		else: $Flipper.scale.x = default_scale
	
	
