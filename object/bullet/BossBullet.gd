extends Node2D

var velocity=Vector2()

var LIFE=5
var lifeTimer=0
# Called when the node enters the scene tree for the first time.
func _ready():
	$damageArea.connect("area_entered",self,"damage")
	pass # Replace with function body.

func _physics_process(delta):
	position+=velocity*delta
	lifeTimer+=delta
	if lifeTimer>=LIFE:
		queue_free()
func damage(area):
	var body=area.get_parent()
	if body && body.has_method("beHit"):
		body.beHit()
	queue_free()