class_name Table extends Area2D

var activated

func _ready():
	activated = false
	$Crouch1.hide()

func activate():
	activated = !activated
	$Crouch1.visible = activated
