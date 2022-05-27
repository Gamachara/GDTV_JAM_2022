extends Enemy

func _physics_process(delta):
	_prep_character_for_update(delta)
	_update_states(delta)
	_update_satan_states(delta)
	_move(delta)
	
func _update_satan_states(delta: float)->void:
	if player_is_to_right(): $Flipper.scale.x = -default_scale
	else: $Flipper.scale.x = default_scale
