extends KinematicBody2D

onready var ani=$ani

var vspeed=0 #水平速度
var hspeed=0

var state="fly" setget set_state
func set_state(value):
	state=value
	

var face=-1 setget set_face
func set_face(value):
	face=value
	self.ani.flip_h=false if value<0 else true
	
#冲刺参数
var dashDir=Vector2()
var dashTimer=0
var DASH_TIME=1
var DASH_SPEED=1000
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
	var player=Global.player
	if position.distance_to(player.position)<1000:
		var direction=position.direction_to(player.position)
		if state=="fly":
			self.face=1 if direction.x>0 else -1
			var target=player.position+Vector2(face*-500,-250)
			position+=(target-position).normalized()*300*delta
			if position.distance_to(target)<50:
				dashDir=(player.position-Vector2(0,20)-self.position+Vector2(0,randf()*40-20)).normalized()
				dashTimer=0
				self.state="dash"
		elif state=="dash":
			position+=dashDir*DASH_SPEED*delta
			dashTimer+=delta
			if dashTimer>=DASH_TIME:
				self.state="fly"
			
func onPlayerEnter(area):
	var body=area.get_parent()
	if body && body.has_method("beHit"):
		body.beHit()