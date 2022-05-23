extends Control

const bar_scale := 1.0
const bar_height := 20
const bar_bg_margin := 2

func _process(delta):
	# If player isn't loaded yet just give up
	if !Global.PLAYER: return
	$Life.set_size(Vector2(Global.PLAYER.life * bar_scale, bar_height))
	$LifeBG.set_size(Vector2(Global.PLAYER.life_max * bar_scale + bar_bg_margin * 2, bar_height + bar_bg_margin * 2))
	$Guard.set_size(Vector2(Global.PLAYER.guard * bar_scale, bar_height))
	$GuardBG.set_size(Vector2(Global.PLAYER.guard_max * bar_scale + bar_bg_margin * 2, bar_height + bar_bg_margin * 2))
