extends Area2D

export var leads = "res://Scenes/Rooms/Corridor1.tscn"
export(bool) var open = true

var hl

func activate():
	if open:
		highlight()
		get_node("AnimationPlayer").play("activate")
	else:
		get_node("SoundLocked").play()

func end():
	get_tree().change_scene(leads)

func highlight():
	hl = !hl
#	if hl:
#		$Sprite.frame = 1
#	else:
#		$Sprite.frame = 0
