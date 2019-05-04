extends Node2D

func _ready():
	$Area2D.connect("area_entered",self,"eat")
	pass # Replace with function body.
func eat(area):
	queue_free()
	Global.player.fly=true
	Global.hasWing=true
	Global.message.play("你获得了天使之翼\n连续按跳跃可以飞行")
	pass

