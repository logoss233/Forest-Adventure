extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.connect("animation_finished",self,"onComplete")
	$AnimatedSprite.play()
	pass # Replace with function body.

func onComplete():
	queue_free()
