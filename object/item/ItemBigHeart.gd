extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	$Area2D.connect("area_entered",self,"eat")
	pass # Replace with function body.
func eat(area):
	queue_free()
	Global.player.max_hp+=1
	Global.player.hp=Global.player.max_hp
	pass
