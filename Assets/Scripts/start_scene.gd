extends Node3D

signal intro
signal bro_fish1

@onready var player = $Player
@onready var playerCam = $"Player/Cutscene Feesh"
@onready var broCam = $"bro_fish/Cutscene Bro"
@onready var UI = $UserInterface
@onready var geraldCam = $Gerald/gerald_cam
@onready var geraldAnim = $Gerald/AnimationPlayer
@onready var gerald = $Gerald
@onready var carrot = preload("res://Assets/Scenes/carrot.tscn")
@onready var larryCam = $Larry/larry_cam
@onready var signCam = $sign/Camera3D
@onready var fishingCam = $"Fishing game/FishingCam"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Intro.current = true
	$Player.canMove = false
	emit_signal("intro")

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	player.canMove = false
	playerCam.current = true
	emit_signal("bro_fish1")


func _on_user_interface_change_to_bro():
	broCam.current = true


func _on_user_interface_change_to_feesh():
	playerCam.current = true


func on_shop_fish_enter(body_rid, body, body_shape_index, local_shape_index):
	UI.interaction()
	player.entering_shop_area()


func on_shop_fish_exit(body_rid, body, body_shape_index, local_shape_index):
	UI.leaving_interaction()
	player.leaving_shop_area()


func closed_shop_button():
	player.left_shop()


func _on_user_interface_change_to_gerald():
	geraldCam.current = true


func in_gerald_area(body_rid, body, body_shape_index, local_shape_index):
	UI.interaction()
	player.entered_gerald()


func leaving_gerald_area(body_rid, body, body_shape_index, local_shape_index):
	UI.leaving_interaction()
	player.leaving_gerald()


func _on_user_interface_show_carrot():
	geraldAnim.play("turn camera")
	var car = carrot.instantiate()
	car.set_name("gerald_carrot")
	add_child(car)
	car.transform.origin = gerald.position
	car.transform.origin.z += 50
	

func sign_camera_swap():
	signCam.current = true

func approaching_sign(body_rid, body, body_shape_index, local_shape_index):
	UI.interaction()
	player.approaching_sign()

func leaving_sign(body_rid, body, body_shape_index, local_shape_index):
	UI.leaving_interaction()
	player.leaving_sign()

func larry_entered(body_rid, body, body_shape_index, local_shape_index):
	if(!player.readyToFish):
		UI.interaction()
		player.approaching_larry()

func larry_left(body_rid, body, body_shape_index, local_shape_index):
	UI.leaving_interaction()
	player.leaving_larry()
	
func _on_user_interface_change_to_larry():
	larryCam.current = true


func entered_fishing(body_rid, body, body_shape_index, local_shape_index):
	if(player.readyToFish):
		UI.interaction()
		player.approaching_fishing()


func left_fishing(body_rid, body, body_shape_index, local_shape_index):
	if(player.readyToFish):
		UI.leaving_interaction()
		player.leaving_fishing()
