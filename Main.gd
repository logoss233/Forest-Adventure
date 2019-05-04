extends Node2D

onready var player=$Map/Player
onready var dieUI=$CanvasLayer/ui/DieUI
onready var boss=$Map/BossPlace/Boss
onready var winUI=$CanvasLayer/ui/WinUI
# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("die",self,"onDie")
	dieUI.connect("complete",self,"dieUIComplete")
	boss.connect("win",self,"onWin")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func onDie():
	get_tree().paused=true
	dieUI.start()
	pass
func dieUIComplete():
	get_tree().paused=false
	Global.dieCount+=1
	player.hp=player.max_hp
	pass
func onWin():
	get_tree().paused=true
	winUI.start()
	pass