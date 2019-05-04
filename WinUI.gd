extends Control

onready var ani=$AnimationPlayer
# Called when the node enters the scene tree for the first time.
signal complete

func _ready():
	pass # Replace with function body.

func start():
	var txt="你打败了boss\n你赢了\n你死了"+String(Global.dieCount)+"次\n"
	if Global.dieCount==0:
		txt+="评价:天才"
	elif Global.dieCount<=1:
		txt+="评价:大佬"
	elif Global.dieCount<=3:
		txt+="评价:高手"
	elif Global.dieCount<=5:
		txt+="评价:不错"
	elif Global.dieCount<=10:
		txt+="评价:还行"
	elif Global.dieCount<=20:
		txt+="评价:菜鸟"
	else:
		txt+="评价:小白"
	$Panel/Label3.text=txt
	visible=true
	ani.play("start")
	yield(ani,"animation_finished")
	pass

