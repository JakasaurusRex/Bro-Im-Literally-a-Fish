extends Control

@onready var viewport = $SubViewport
@onready var fish_sprite = $Sprite2D2
@onready var menu_bg = $menu_bg
# Called when the node enters the scene tree for the first time.
func _ready():
	$Text/Timer.start(0.5)
	menu_bg.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://Assets/Scenes/start_scene.tscn")
		
	fish_sprite.texture = viewport.get_texture()
	
func _on_timer_timeout():
	if $Text.frame == 0:
		$Text.frame = 1
	else:
		$Text.frame = 0
	$Text/Timer.start(0.5)
	


func _on_menu_bg_finished():
	menu_bg.play()
