extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Text/Timer.start(0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://Assets/Scenes/start_scene.tscn")
	
func _on_timer_timeout():
	if $Text.frame == 0:
		$Text.frame = 1
	else:
		$Text.frame = 0
	$Text/Timer.start(0.5)
	
