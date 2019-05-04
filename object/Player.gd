extends KinematicBody2D
class_name Player

signal die

var effect_doubleJump=preload("res://effect/DoubleJumpEffect.tscn")
var effect_wing=preload("res://effect/WingEffect.tscn")
var tscn_swordWind=preload("res://object/bullet/SwordWind.tscn")
onready var ani=$ani
onready var winAni=$wingAniContainer/wingAni
onready var winAniContainer=$wingAniContainer
onready var swordDamageArea=$swordDamageContainer/swordDamageArea
onready var swordDamageContainer=$swordDamageContainer
onready var hitArea=$hitArea


var face=-1 setget set_face
func set_face(value):
	face=value
	self.ani.flip_h=false if value<0 else true
	winAniContainer.scale.x=-1 if value>0 else 1
	swordDamageContainer.scale.x=-1 if value>0 else 1
#状态
var state="" setget set_state
func set_state(value):
	swordDamageAreaOff()
	
	state=value
	match state:
		"normal":
			pass
	pass

#生命
var hp=3 setget set_hp
func set_hp(value):
	if value>max_hp:
		value=max_hp
	hp=value
	if value<=0:
		emit_signal("die")
var max_hp=3

#移动参数
#var velocity=Vector2() #当前的速度
var dir=0 #按键操作的方向
var moveSpeed=0   #移动速度
var vspeed=0 #水平速度

var MOVE_ADD_SPEED=50 #移动加速度
var MOVE_SPEED_REDUCE=50 #不动时的阻力
var MAX_MOVE_SPEED=700 #最大移动速度
var MAX_VSPEED=1000  #最大下落速度
var GRAVITY=50 #重力
var JUMP_SPEED=1000 #跳跃的速度

#跳跃参数
var fly=false #无限跳的能力
var doubleJump=false #二段跳的能力
var jumpCount=0 #二段跳时计数
#攻击参数
var power=false

#----------动画相关参数------------


func _ready():
	Global.player=self
	self.face=1
	self.state="normal"
	ani.connect("animation_finished",self,"onAniFinished")
	ani.connect("frame_changed",self,"onAniFrameChange")
	winAni.connect("animation_finished",self,"onWingAniFinished")
	swordDamageArea.connect("area_entered",self,"damageArea")
	pass # Replace with function body.

func _physics_process(delta):
	dir=0 #按键操作的方向
	if Input.is_action_pressed("a"):
		dir-=1
	if Input.is_action_pressed("d"):
		dir+=1
	#重置跳跃计数
	if is_on_floor():
		jumpCount=0
	
	match self.state:
		"normal":
			if is_on_floor():
				move_process()
			else:
				move_process()
			jump_process()
			
			#攻击
			if Input.is_action_just_pressed("j"):
				self.set_state("attack")
		"attack":
			if is_on_floor():
				moveSpeed=0
				jump_process()
			else:
				#和移动不同 不会改变朝向
				self.moveSpeed+=dir*MOVE_ADD_SPEED
				self.moveSpeed=clamp(self.moveSpeed,-MAX_MOVE_SPEED,MAX_MOVE_SPEED)
				if dir==0 && moveSpeed!=0:
					moveReduce_process()
				jump_process()
	#重力加速度
	vspeed+=GRAVITY
	if vspeed>MAX_VSPEED:
		vspeed=MAX_VSPEED
	
	var v=move_and_slide(Vector2(moveSpeed,vspeed),Vector2(0,-1))
	vspeed=v.y
	if is_on_floor() && vspeed>0:
		vspeed=0
		
	#更新动画
	if self.state=="normal":
		if is_on_floor():
			if moveSpeed==0 &&dir==0:
				ani.play("idle")
			else:
				ani.play("run")
		else:
			ani.play("jump")
	elif self.state=="attack":
		ani.play("attack")
	#更新受伤状态
	hit_process(delta)


#----------拆分功能
func move_process():
	if dir!=0:
		self.face=sign(dir)
	if is_on_floor() && sign(dir)!=sign(moveSpeed):
		moveSpeed=0
	self.moveSpeed+=dir*MOVE_ADD_SPEED
	self.moveSpeed=clamp(self.moveSpeed,-MAX_MOVE_SPEED,MAX_MOVE_SPEED)
	if dir==0 && moveSpeed!=0:
		if is_on_floor():
			moveSpeed=0
		else:
			moveReduce_process()
func moveReduce_process():
	if moveSpeed>0:
		moveSpeed-=MOVE_SPEED_REDUCE
		if moveSpeed<0:
			moveSpeed=0
	else:
		moveSpeed+=MOVE_SPEED_REDUCE
		if moveSpeed>0:
			moveSpeed=0
func jump_process():
	#跳跃
	if Input.is_action_just_pressed("k"):
		if is_on_floor():
			self.vspeed=-JUMP_SPEED
			jumpCount=0
		else:
			#二段跳
			if doubleJump &&jumpCount==0:
				self.vspeed=-JUMP_SPEED
				jumpCount+=1
				var effect=effect_doubleJump.instance()
				get_parent().add_child(effect)
				effect.position=self.position
			#飞行
			elif fly:
				self.vspeed=-JUMP_SPEED
#						var effect=effect_doubleJump.instance()
#						get_parent().add_child(effect)
#						effect.position=self.position
				winAni.visible=true
				winAni.frame=0
				winAni.play()
				
#------------受击
var isHit=false setget set_isHit
func set_isHit(value):
	isHit=value
	if value:
		modulate.a=0.5
		hitAreaOff()
		hitTimer=0
	else:
		modulate.a=1
		hitAreaOn()
	pass
var hitTimer=0
var HITTIME=1
func beHit():
	self.hp-=1
	self.vspeed=-JUMP_SPEED*0.8
	self.isHit=true
	pass
func hit_process(delta):
	if isHit:
		hitTimer+=delta
		if hitTimer>=HITTIME:
			self.isHit=false
#----------
func swordDamageAreaOn():
	swordDamageArea.collision_mask=4
	pass
func swordDamageAreaOff():
	swordDamageArea.collision_mask=0
	pass
func hitAreaOn():
	hitArea.collision_layer=2
func hitAreaOff():
	hitArea.collision_layer=0
#----------回调
func onAniFinished():
	if self.state=="attack":
		self.state="normal"
	pass
func onAniFrameChange():
	if state=="attack":
		if ani.frame==1:
			swordDamageAreaOn()
		elif ani.frame==2:
			swordDamageAreaOff()
			if power:
				var w=tscn_swordWind.instance()
				get_parent().add_child(w)
				w.position=self.position+Vector2(30*face,-10)
				w.face=self.face
				pass
	pass
func onWingAniFinished():
	winAni.visible=false
	pass
func damageArea(area):
	var body=area.get_parent()
	if body &&body.has_method("beHit"):
		body.beHit()
		pass