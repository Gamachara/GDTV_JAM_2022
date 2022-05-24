extends Character

onready var hurtbox = $Flipper/P_Hurtbox

onready var front_hand_sword 	= $Flipper/Node2D/Pelvis/Torso/Sword_Upperarm/Sword_Forearm/FRONT_HAND_SWORD
onready var front_hand_shield 	= $Flipper/Node2D/Pelvis/Torso/Sword_Upperarm/Sword_Forearm/FRONT_HAND_SHEILD
onready var back_hand_sword 	= $Flipper/Node2D/Pelvis/Torso/Shield_upperarm/Shield_forearm/BACK_HAND_SWORD
onready var back_hand_shield 	= $Flipper/Node2D/Pelvis/Torso/Shield_upperarm/Shield_forearm/BACK_HAND_SHIELD
onready var rip1				= $Flipper/Node2D/Pelvis/Torso/rip1
onready var rip2				= $Flipper/Node2D/Pelvis/Torso/rip2

var xp :int = 0
var xp_to_level :int = 100
var level : int = 1

func _ready():
	Global.PLAYER = self
	walk_speed = 250
	walk_speed_guard = 110
	jump_speed = -500

func _physics_process(delta):
	_prep_character_for_update(delta)
	
	if jump_try_window > 0: jump_try_window -= delta
	if jump_try_window < 0: jump_try_window = 0
	
	if taking_input: _take_input()
	else: movevec.x = 0
	
	_update_states(delta)
	_move(delta)
	
	#VISUAL
	#change hands on flip
	if $Flipper.scale.x < 0:
		rip1.show()
		front_hand_shield.show()
		back_hand_sword.show()
		
		rip2.hide()
		back_hand_shield.hide()
		front_hand_sword.hide()
		
	else:
		rip2.show()
		back_hand_shield.show()
		front_hand_sword.show()
		
		rip1.hide()
		front_hand_shield.hide()
		back_hand_sword.hide()
		
	#modulate
	if stun_clock: modulate = mod_hit_flash
	elif guarding and guard: modulate = Color.green # testing
	else: modulate = mod_default

func _take_input() -> void:
	in_left 	= Input.is_action_pressed('ui_left')
	in_right 	= Input.is_action_pressed('ui_right')
	in_down 	= Input.is_action_pressed('ui_down')
	in_jump 	= Input.is_action_just_pressed('ui_jump')
	in_attack 	= Input.is_action_just_pressed('ui_attack')
	in_guard 	= Input.is_action_pressed('ui_guard')
	in_parry 	= Input.is_action_just_pressed('ui_guard')

func _on_P_Hurtbox_area_entered(area):
	if !incoming_hitbox: incoming_hitbox = area
