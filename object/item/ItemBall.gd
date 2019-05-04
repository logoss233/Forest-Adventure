extends Node2D




func _ready():
	$Area2D.connect("area_entered",self,"eat")
	pass # Replace with function body.
func eat(area):
	queue_free()
	Global.player.doubleJump=true
	Global.hasBall=true
	Global.message.play("你获得了风之珠\n现在可以使用二段跳了")
	pass

