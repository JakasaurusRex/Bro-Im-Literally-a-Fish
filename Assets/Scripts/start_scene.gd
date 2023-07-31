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
@onready var hatFish = $hat_fish
@onready var hatFishAnim = $hat_fish/AnimationPlayer
@onready var larry = $Larry
@onready var shop_sfx = $"Shop/Shop sfx"
@onready var sean_cam = $speedrunner/Camera3D
@onready var sean_anim = $speedrunner/AnimationPlayer2
@onready var sean = $speedrunner
@onready var ui_anim = $UserInterface/AnimationPlayer
@onready var cinematic_cam = $"Cinematic Camera"
@onready var bubbles = $Surroundings/bubbles
var volacno = false
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
	shop_sfx.play()
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
		
func _on_user_interface_change_to_fishing():
	fishingCam.visible = true
	fishingCam.current = true


func _on_fishing_cam_lost_fish_signal():
	UI.lost_fish()
	larryCam.current = true
	$Player/BG.play()

func _on_fishing_cam_scared_fish_signal():
	UI.scared_fish()
	larryCam.current = true
	$Player/BG.play()

func _on_fishing_cam_left_fishing():
	player._on_user_interface_over()
	UI.interaction()
	player.approaching_fishing()
	$Player/BG.play()

func _on_fishing_cam_fish_too_fast():
	UI.fish_too_fast()
	larryCam.current = true
	$Player/BG.play()

func _on_fishing_cam_caught_fish():
	UI.nice_catch()
	larryCam.current = true
	$Player/BG.play()

func _on_shop_all_hats():
	hatFishAnim.play("turn")
	var car = carrot.instantiate()
	car.set_name("hatfish_carrot")
	add_child(car)
	car.transform.origin = hatFish.position
	car.transform.origin.x += 50



func _on_user_interface_spawn_larry():
	var car = carrot.instantiate()
	car.set_name("larry_carrot")
	add_child(car)
	car.transform.origin = larry.position
	car.transform.origin.x += 40
	car.transform.origin.z += 20


func sean_entered(body_rid, body, body_shape_index, local_shape_index):
	UI.interaction()
	player.entered_sean()


func sean_exited(body_rid, body, body_shape_index, local_shape_index):
	UI.leaving_interaction()
	player.leaving_sean()

func swap_to_sean():
	sean_cam.current = true


func _on_user_interface_show_sean():
	sean_anim.play("turn")
	var car = carrot.instantiate()
	car.set_name("sean_carrot")
	add_child(car)
	car.transform.origin = sean.position
	car.transform.origin.x -= 40


func _on_volcano_area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	volacno = true
	UI.volcano = true
	ui_anim.play("fade_to_black")
	


func _on_win_area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	UI.beat_game = true
	ui_anim.play("fade_to_black")
	get_tree().change_scene_to_file("res://Assets/Scenes/end.tscn")


func _on_user_interface_explosion_time():
	cinematic_cam.current = true
	bubbles.particles.emitting = true
	bubbles.audio.play()
	player.rotation.x = 90
	player.flying = true
	
