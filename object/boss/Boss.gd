extends Node2D
class_name Boss

signal win
var tscnBullet=preload("res://object/bullet/BossBullet.tscn")
var tscnEagle=preload("res://object/enemy/Eagle.tscn")
var tscnBoom=preload("res://effect/EnemyDie.tscn")
onready var ani=$AnimationPlayer
onready var damageArea=$damageArea

#sleep battle
var state="sleep" setget set_state
func set_state(value):
	state=value
	pass

var hp=20 setget set_hp
func set_hp(value):
	hp=value
	if hp<=0:
		die()
	pass
var max_hp=20
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.boss=self
	damageArea.connect("area_entered",self,"onPlayerEnter")
	pass # Replace with function body.

func _physics_process(delta):
	if state=="battle":
		if position.distance_to(Global.player.position)<1200:
			bullet_process(delta)
			eagle_process(delta)
		
		pass

func die():
	self.state="die"
	$hitArea.collision_layer=0
	$damageArea.collision_mask=0
	$boss_ball.visible=false
	for i in range(200):
		boom()
		yield(get_tree().create_timer(0.03),"timeout")
	$sprite.texture=load("res://sprite/boss/boss_die.png")
	yield(get_tree().create_timer(2),"timeout")
	emit_signal("win")
	
	pass
func beHit():
	ani.play("beHit")
	if state=="sleep":
		self.state="battle"
	elif state=="battle":
		self.hp-=1
	pass
func onPlayerEnter(area):
	var body=area.get_parent()
	if body && body.has_method("beHit"):
		body.beHit()


var cdTimer=0
var CD=1
func bullet_process(delta):
	cdTimer+=delta
	if cdTimer>=CD:
		shoot()
		cdTimer=0
	
	pass
func shoot():
	var bullet=tscnBullet.instance()
	get_parent().add_child(bullet)
	bullet.position=self.position
	bullet.velocity=position.direction_to(Global.player.position).normalized()*700

var eagleTimer=0
var eagleCD=5
func eagle_process(delta):
	eagleTimer+=delta
	if eagleTimer>=eagleCD:
		createEagle()
		eagleTimer=0
	pass
func createEagle():
	var eagle=tscnEagle.instance()
	get_parent().add_child(eagle)
	eagle.position=self.position
	pass
func boom():
	var b=tscnBoom.instance()
	get_parent().add_child(b)
	b.position=self.position+Vector2(rand_range(-650,100),rand_range(-300,550))
	pass