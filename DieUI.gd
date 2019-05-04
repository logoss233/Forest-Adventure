extends Control

onready var ani=$AnimationPlayer
# Called when the node enters the scene tree for the first time.
signal complete

var state="deactive"
func _ready():
	pass # Replace with function body.

func start():
	visible=true
	ani.play("start")
	yield(ani,"animation_finished")
	self.state="active"
	pass
func _process(delta):
	if state=="active" &&Input.is_action_just_pressed("blank"):
		end();
func end():
	self.state="deactive"
	ani.play("end")
	yield(ani,"animation_finished")
	emit_signal("complete")