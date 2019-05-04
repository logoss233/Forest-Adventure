extends Control

var heartTexture=preload("res://sprite/item/heart.png")
var emptyHeartTexture=preload("res://sprite/item/heartEmpty.png")
var lifeSpriteList=[]

func _ready():
	lifeSpriteList.append($"1")
	lifeSpriteList.append($"2")
	lifeSpriteList.append($"3")
	lifeSpriteList.append($"4")
	lifeSpriteList.append($"5")

func setLife(life,maxLife):
	for i in range(5):
		if maxLife-1>=i:
			lifeSpriteList[i].visible=true
			if life-1>=i:
				lifeSpriteList[i].texture=heartTexture
			else:
				lifeSpriteList[i].texture=emptyHeartTexture
		else:
			lifeSpriteList[i].visible=false

func _physics_process(delta):
	if !Global.player:
		return
	setLife(Global.player.hp,Global.player.max_hp)