extends Node2D

func _ready():
	$Area2D.connect("area_entered",self,"eat")
	pass # Replace with function body.
func eat(area):
	queue_free()
	Global.player.hp+=1
	pass


