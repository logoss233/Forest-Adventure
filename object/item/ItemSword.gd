extends Node2D



func _ready():
	$Area2D.connect("area_entered",self,"eat")
	pass # Replace with function body.
func eat(area):
	queue_free()
	Global.player.power=true
	Global.hasSword=true
	Global.message.play("你获得了波动剑\n攻击会发出剑气")
	pass

