extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var dieText=$dieText
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	dieText.text=String(Global.dieCount)
	pass