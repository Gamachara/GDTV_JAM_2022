class_name Character
extends KinematicBody2D

# Grab default modulation for easy undoing of modulation
var mod_default : Color = modulate
var mod_hit_flash : Color = Color.whitesmoke

var x_dir_mult := 0
var voluntary_movevec := Vector2.ZERO
var involuntary_movevec := Vector2.ZERO

var stun_clock := 0.0

export (float) var walk_speed := 200
export (float) var jump_speed := -800

export (float) var life_max = 100.0

export (float) var guard_damage_reduction = 0.7
export (float) var guard_push_reduction = 0.7
export (float) var guard_max = 100.0
export (float) var guard_replenlish = 10.0

var life : float = life_max
var guard : float = guard_max

var guarding := false

func _prep_character_for_update(delta : float) -> void:
	voluntary_movevec = Vector2.ZERO
	involuntary_movevec = Vector2.ZERO
	
	if not guarding and guard < guard_max: guard += guard_replenlish * delta
	
	if life > life_max: life = life_max
	if guard > guard_max: guard = guard_max
	
	if stun_clock > 0: stun_clock -= delta
	if stun_clock < 0: stun_clock = 0

func _physics_process(delta):
	_prep_character_for_update(delta)


func _move(delta : float)-> void:
	
	
	move_and_slide(involuntary_movevec + voluntary_movevec, Vector2.UP)

func _can_move() -> bool:
	return (
		!involuntary_movevec.x and 
		!involuntary_movevec.y < 0 and
		!stun_clock)
