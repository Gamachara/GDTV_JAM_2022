class_name Character
extends KinematicBody2D

onready var AP = $AnimationPlayer

export (Script) var controller = null
#onready var controller = load(controller_path)

# Inputs
# These same variables are used by AI
var in_left 	:= false
var in_right 	:= false
var in_down 	:= false
var in_jump 	:= false
var in_attack 	:= false
var in_guard 	:= false
var in_parry 	:= false

# Grab default modulation for easy undoing of modulation
var mod_default : Color = modulate
var mod_hit_flash : Color = Color.webgray

var x_dir_mult := 0
var movevec := Vector2.ZERO
var pushvec := Vector2.ZERO

var anim := "stand"

export (float) var walk_speed := 200
export (float) var walk_speed_guard := 75
export (float) var jump_speed := -800

export (float) var life_max = 100.0
export (float) var life_replenlish = 2.0

export (float) var guard_damage_reduction = 0.7
export (float) var guard_push_reduction = 0.4
export (float) var guard_max = 100.0
export (float) var guard_replenlish = 2.0

export (float) var stun_time = 0.5
export (float) var stun_crit_time = 1.0

var jump_fudge_time := 0.15
var jump_try_window := 0.0

var stun_clock := 0.0

var life : float = life_max
var guard : float = guard_max

var taking_input := true
var guarding := false
export (bool) var anim_lock := false

var incoming_hitbox : Area2D = null

func _prep_character_for_update(delta : float) -> void:
	# Rest inputs
#	in_left 	= false
#	in_right 	= false
#	in_down 	= false
#	in_jump 	= false
#	in_attack 	= false
#	in_guard 	= false
#	in_parry 	= false
	
	# Replenish guard
	if !guarding and guard < guard_max: guard += guard_replenlish * delta
	if guard > guard_max: guard = guard_max
	
	# Replenish life
	if life < life_max: life += life_replenlish * delta
	if life > life_max: life = life_max
	
	if stun_clock > 0: stun_clock -= delta
	if stun_clock < 0: stun_clock = 0
	
	movevec.x = 0
	movevec.y += (Global.GRAVITY * delta)

func _physics_process(delta):
	_prep_character_for_update(delta)
#	controller.update_behavior(self)
	_update_states(delta)
	if incoming_hitbox: _react_to_hit(incoming_hitbox)
	_move(delta)

func _update_states(delta : float):
	taking_input = !(
		movevec.x or 
		anim_lock or
		stun_clock)
	
	if taking_input: x_dir_mult = int(in_right) - int(in_left)
	
	guarding = (
		taking_input
		and in_guard
		and guard
		and is_on_floor())
	
	if !AP: return
	if anim_lock and AP.is_playing(): return
	var new_anim := anim
	
	if stun_clock: new_anim = "hurt"
	elif !is_on_floor(): new_anim = "air"
	elif taking_input and (in_left or in_right):
		if guarding: new_anim = "guard_walk"
		else: new_anim = "walk"
	elif guarding: new_anim = "guard"
	elif in_attack:
		if x_dir_mult > -1: new_anim = "attack_fronthand"
		if x_dir_mult < 0: new_anim = "attack_backhand"
		print(x_dir_mult)
	else: new_anim = "stand"
	
	if anim != new_anim:
		anim = new_anim
		AP.play(anim, .2)
#		print(anim)

func _move(delta : float)-> void:
	
	if taking_input:
		var adj_speed = walk_speed
		if guarding: adj_speed = walk_speed_guard
		
		movevec.x += x_dir_mult * adj_speed
	
	if !guarding and x_dir_mult: $Flipper.set_scale(Vector2(x_dir_mult, 1))
	
	if in_jump: jump_try_window = jump_fudge_time

	if jump_try_window and is_on_floor():
		jump_try_window = 0
		movevec.y += jump_speed
	
	if pushvec:
		var adj_push = pushvec * delta
		movevec += adj_push
		pushvec -= adj_push
	movevec = move_and_slide(movevec, Vector2.UP)

func _react_to_hit(hit : Area2D):
	
#	#Check for parry
#	var is_in_parry_window = hit.get("in_parry_window")
#	if is_in_parry_window and in_parry and taking_input:
#		# TODO Parry
#		_parry_feedback()
#		return

	# Take damage
	var incoming_damage = hit.get("damage")
	
	# Ignore guard if attacked from behind
	# TODO fix this it's broken
	var guarded_hit = guarding 
	if hit.global_position.x < global_position.x and x_dir_mult < 1: guarded_hit = false
	elif hit.global_position.x > global_position.x and x_dir_mult > -1: guarded_hit = false
	
	if guarded_hit:
		guard -= hit.get("guard_break")
		if guard <= 0: _guard_break_feedback()
		else: incoming_damage *= guard_damage_reduction
		
		
	life -= incoming_damage
	if life <= 0:
		life = 0
		# TODO death
		return
	if guard <= 0: guard = 0
	
		
	# stun
	var is_crit = hit.get("crit")
	if is_crit: stun_clock = stun_time
	else: stun_clock = stun_crit_time
	
	
	# Be pushed
	var push = hit.get("push")
	if guarding: push *= guard_push_reduction
	if hit.global_position.x > global_position.x: push *= -1
	pushvec.x += push
	
	incoming_hitbox = null
	
func _guard_break_feedback() -> void:
	pass

func _parry_feedback() -> void:
	pass
