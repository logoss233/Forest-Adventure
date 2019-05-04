extends KinematicBody2D

onready var ani=$ani
onready var downRay=$flipContainer/downRay
onready var upRay=$flipContainer/upRay

var vspeed=0 #水平速度
var MAX_VSPEED=800  #最大下落速度
var GRAVITY=50 #重力

var face=-1 setget set_face

#跳跃功能


func set_face(value):
	face=value
	self.ani.flip_h=false if value<0 else true
	$flipContainer.scale.x=1 if value<0 else -1
func _ready():
	$damageArea.connect("area_entered",self,"onPlayerEnter")
	pass # Replace with function body.

func beHit():
	
	queue_free()
	var effect=load("res://effect/EnemyDie.tscn").instance()
	get_parent().add_child(effect)
	effect.position=self.position
	pass

func _physics_process(delta):
	var hspeed=0
	var player=Global.player
	if position.distance_to(player.position)<1000:
		if is_on_floor():
			if upRay.is_colliding():
				self.face=-self.face
			elif !downRay.is_colliding():
				self.face=-self.face
				pass
		hspeed=face*500
		pass
	
	
	vspeed+=GRAVITY
	if vspeed>MAX_VSPEED:
		vspeed=MAX_VSPEED
	var v=move_and_slide(Vector2(hspeed,vspeed),Vector2(0,-1))
	vspeed=v.y
	if is_on_floor() && vspeed>0:
		vspeed=0
	
	
func onPlayerEnter(area):
	var body=area.get_parent()
	if body && body.has_method("beHit"):
		body.beHit()