extends Control

onready var ball=$ball
onready var sword=$sword
onready var wing=$wing
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	ball.visible=true if Global.hasBall else false
	sword.visible=true if Global.hasSword else false
	wing.visible=true if Global.hasWing else false
