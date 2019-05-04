extends Node2D

var face=-1 setget set_face
func set_face(value):
	face=value
	$Sprite.scale.x=-value*4
var SPEED=1700
var LIFE=0.4
var lifeTimer=0
# Called when the node enters the scene tree for the first time.
func _ready():
	$damageArea.connect("area_entered",self,"damage")
	pass # Replace with function body.

func _physics_process(delta):
	position.x+=face*delta*SPEED
	lifeTimer+=delta
	if lifeTimer>=LIFE:
		queue_free()
func damage(area):
	var body=area.get_parent()
	if body && body.has_method("beHit"):
		body.beHit()
	queue_free()