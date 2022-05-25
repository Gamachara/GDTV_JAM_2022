extends Character

func _physics_process(delta):
	_prep_character_for_update(delta)
	_update_states(delta)
	_update_satan_states(delta)
	_move(delta)
	
func _update_satan_states(delta: float)->void:
	pass


func _on_Hurtbox_area_entered(area):
	if !incoming_hitbox: incoming_hitbox = area
