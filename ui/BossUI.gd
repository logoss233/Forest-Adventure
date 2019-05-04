extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var healthBar=$healthBar
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var boss=Global.boss
	if boss.state=="battle":
		visible=true
	else:
		visible=false
	healthBar.rect_scale.x=float(boss.hp)/boss.max_hp
	if healthBar.rect_scale.x<0:
		healthBar.rect_scale.x=0 