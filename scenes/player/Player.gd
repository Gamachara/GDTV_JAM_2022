extends Character

onready var hurtbox = $Flipper/P_Hurtbox

var jump_fudge_time := 0.15
var jump_try_window := 0.0

# Inputs
var in_left 	:= false
var in_right 	:= false
var in_down 	:= false
var in_jump 	:= false
var in_attack 	:= false
var in_guard 	:= false
var in_parry 	:= false

func _ready():
	walk_speed = 200
	jump_speed = -800

func _physics_process(delta):
	_prep_character_for_update(delta)
	involuntary_movevec = Vector2(0, Global.GRAVITY * delta)
	
	if jump_try_window > 0: jump_try_window -= delta
	if jump_try_window < 0: jump_try_window = 0
	
	_adjust_movement(delta)
	_move(delta)

func _take_input() -> void:
	in_left 	= Input.is_action_pressed('ui_left')
	in_right 	= Input.is_action_pressed('ui_right')
	in_down 	= Input.is_action_pressed('ui_down')
	in_jump 	= Input.is_action_just_pressed('ui_select')
	in_attack 	= Input.is_action_just_pressed('ui_attack')
	in_guard 	= Input.is_action_pressed('ui_guard')
	in_parry 	= Input.is_action_just_pressed('ui_guard')

func _adjust_movement(delta : float) -> void:
	

	
	if not _can_move(): return
	
	_take_input()
	x_dir_mult = int(in_right) - int(in_left)
	voluntary_movevec.x += x_dir_mult * walk_speed
	
	if x_dir_mult: $Flipper.set_scale(Vector2(x_dir_mult, 1))
	
	if in_jump: jump_try_window = jump_fudge_time
	
	if jump_try_window and is_on_floor():
		jump_try_window = 0
		voluntary_movevec.y = jump_speed


func _on_hit_player(hit : Area2D):
	# Be pushed
	var push = hurtbox.get("push")
	if guard and guarding: push *= guard_push_reduction
	involuntary_movevec += push
	
	var incoming_damage = hit.get("damage")

	if guard and guarding:
		guard -= hit.get("guard_break")
		if guard <= 0:
			guard = 0
			# TODO guard_break feedback
		else:
			incoming_damage *= guard_damage_reduction
	
	life -= incoming_damage
	if life <= 0:
		life = 0
