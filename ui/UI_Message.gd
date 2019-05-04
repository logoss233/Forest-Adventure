extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.message=self
	pass # Replace with function body.

func play(txt):
	$Label.text=txt
	$AnimationPlayer.play("新建动画")
	pass
