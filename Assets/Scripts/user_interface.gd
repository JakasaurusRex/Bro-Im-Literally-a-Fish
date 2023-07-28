extends Control

signal transitioned
# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = false
	$ColorRect.color = Color(0, 0, 0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_bebes(carrots):
	print(carrots)
	if carrots > 100:
		$bebeCarrotLeftNum.frame = carrots / 100
		$bebeCarrotMiddleNum.frame = carrots % 100 / 10
		$bebeCarrotRightNum.frame = carrots % 100 % 10
	elif carrots > 10:
		$bebeCarrotLeftNum.frame = 0
		$bebeCarrotMiddleNum.frame = carrots / 10
		$bebeCarrotRightNum.frame = carrots % 10
	else:
		$bebeCarrotLeftNum.frame = 0
		$bebeCarrotMiddleNum.frame = 0
		$bebeCarrotRightNum.frame = carrots % 10

func transition():
	print("transitioning")
	$ColorRect.visible = true
	$AnimationPlayer.play("fade_to_black")

func _on_animation_player_animation_finished(anim_name):
	print("finished")
	if(anim_name == "fade_to_black"):
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_normal")
	if(anim_name == "fade_to_normal"):
		$ColorRect.visible = false

	
