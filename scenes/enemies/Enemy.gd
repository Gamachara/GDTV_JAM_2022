class_name Enemy
extends Character

var activated := false
var activation_distance := 700

func dist_to_player()-> float:
	return global_position.distance_to(Global.PLAYER.global_position)

func player_is_to_right() -> bool:
	return (Global.PLAYER.global_position.x > self.global_position.x)
