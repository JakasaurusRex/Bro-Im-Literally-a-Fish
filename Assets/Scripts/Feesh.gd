extends CharacterBody3D

@export var speed = 10.0
@export var jumpStrength = 30.0
@export var gravity = -50.0
@export var acceleration = 70
@export var friction = 100 
@export var air_fric = 10
@export var mouse_sens = 0.1
@export var rot_speed = 15
@export var bebe_carrots = 0
@export var fishes = 0
@export var carots = 0
@export var startingPos = Vector3(429.853, 14.103, 465.986)
@export var readyToFish = false

@onready var _springArm = $SpringArm
@onready var pivot = $Pivot
var _snapVector = Vector3.ZERO
@export var canMove = false

@onready var gentleHat = $Pivot/feesh/hatshop
@onready var strawHat = $Pivot/feesh/Sphere_002
@onready var bassHat = $Pivot/feesh/Sphere_001
@onready var fearHat = $Pivot/feesh/Cylinder

@onready var shop = $"../Shop"
@onready var ui = $"../UserInterface"
@onready var fishing_rod = $Pivot/fishingrod
@onready var gerald_prog = 0
@onready var jumpSFX = $Jump
@onready var bebeSfx = $Eatbebe
@onready var carrotSfx = $Eatbig
@onready var fishingSfx = $Fishing
@onready var BG = $BG
@onready var leg1 = $Pivot/feesh/Leg1
@onready var leg2 = $Pivot/feesh/Leg2

@export var flying = false

var gerald = false

var shop_fish = false
var sign = false
var larry = false
var fishing = false
var sean = false
var leg_scene = false

@export var currentHat = ""


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	update_hat()
	BG.play()
	leg1.visible = false
	leg2.visible = false
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and canMove:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		_springArm.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		_springArm.rotation.x = clamp(_springArm.rotation.x, deg_to_rad(-75), deg_to_rad(75))
		if(leg_scene == false and carots == 4):
			leg1.visible = true
			leg2.visible = true
			jumpStrength = 150
			leg_scene = true
			canMove = false
			velocity = Vector3.ZERO
			$".."._on_user_interface_change_to_feesh()
			ui.leg_scene()
	
func _physics_process(delta):
	if(flying):
		velocity.y += 3
		scale = Vector3(15, 15, 15)
	if Input.is_action_just_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if shop_fish and Input.is_action_just_pressed("interact"):
		entered_shop()
	elif gerald and Input.is_action_just_pressed("interact"):
		talked_to_gerald()
	elif sign and Input.is_action_just_pressed("interact"):
		reading_sign()
	elif larry and Input.is_action_just_pressed("interact"):
		talked_to_larry()
	elif fishing and Input.is_action_just_pressed("interact"):
		fishing = false
		fishingSfx.play()
		ui.leaving_interaction()
		opened_fishing()
		BG.stop()
	elif sean and Input.is_action_just_pressed("interact"):
		talk_to_sean()
	
	if readyToFish:
		fishing_rod.visible = true
	else:
		fishing_rod.visible = false
	
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(input_vector, direction, delta)
	apply_gravity(delta)
	apply_friction(direction, delta)
	jump()
	move_and_slide()
	
	
func get_input_vector():
	if !canMove:
		return
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	return input_vector.normalized() if input_vector.length() > 1  else input_vector
	
func get_direction(input_vector):
	if !canMove:
		return
	var direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	

func apply_friction(input_direction, delta):
	if !canMove:
		return
	if input_direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(input_direction * speed, air_fric * delta).x
			velocity.z = velocity.move_toward(input_direction * speed, air_fric * delta).z

func apply_movement(input_vector, direction, delta):
	if !canMove:
		return
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * speed, acceleration * delta).z
		# pivot.look_at(global_transform.origin + direction, Vector3.UP)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-input_vector.x, -input_vector.z), rot_speed * delta)
		
func apply_gravity(delta):
	if !canMove:
		return
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jumpStrength)
	
	
func jump():
	if !canMove:
		return
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			jumpSFX.play()
			velocity.y = jumpStrength
		elif Input.is_action_just_released("jump") and velocity.y > jumpStrength/2:
			velocity.y = jumpStrength/2

		
func update_hat():
	if currentHat == "gentle":
		gentleHat.visible = true
		strawHat.visible = false
		bassHat.visible = false
		fearHat.visible = false
	elif currentHat == "straw":
		gentleHat.visible = false
		strawHat.visible = true
		bassHat.visible = false
		fearHat.visible = false
	elif currentHat == "bass":
		gentleHat.visible = false
		strawHat.visible = false
		bassHat.visible = true
		fearHat.visible = false
	elif currentHat == "fear":
		gentleHat.visible = false
		strawHat.visible = false
		bassHat.visible = false
		fearHat.visible = true
	else:
		gentleHat.visible = false
		strawHat.visible = false
		bassHat.visible = false
		fearHat.visible = false

func _on_bebe_carrot_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	bebe_carrots += 1
	ui.update_bebes(bebe_carrots)
	bebeSfx.play()
	
	

	

func entered_pond(body_rid, body, body_shape_index, local_shape_index):
	print("entered pond")
	canMove = false
	ui.transition()
	
	


func _on_user_interface_transitioned():
	ui.pond_scene = true
	$".."._on_user_interface_change_to_bro()
	position = startingPos
	ui.pond()


func _on_user_interface_over():
	if(gerald_prog==0 and gerald):
		gerald_prog = 1
	elif(currentHat == "gentle" and gerald):
		gerald_prog = 2
	elif(larry):
		readyToFish = true
	canMove = true
	$SpringArm/Camera3D.current = true
	$"../UserInterface/ColorRect2".visible = false
	
	
func eat_carrot(carrot):
	carrotSfx.play()
	canMove = false
	$"Cutscene Feesh".current = true
	carrot.transform.origin = position
	carrot.transform.origin.y += 30
	carrot.animate()
	pivot.rotation.x += deg_to_rad(90)
	velocity = Vector3(0, 0, 0)
	
func done_eating():
	canMove = true
	pivot.rotation.x -= deg_to_rad(90)
	$"Cutscene Feesh".current = true
	$SpringArm/Camera3D.current = true
	$"../UserInterface".update_carots(carots)
	carots += 1
	ui.update_carots(carots)
	
	
func entering_shop_area():
	shop_fish = true
	print("trying to enter")
	

func leaving_shop_area():
	shop_fish = false

func entered_shop():
	canMove = false
	velocity = Vector3.ZERO
	$"../hat_fish/Camera3D".current = true
	ui.visible = false
	shop.visible = true
	shop.bebes = bebe_carrots
	shop.fishes = fishes
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func left_shop():
	canMove = true
	$SpringArm/Camera3D.current = true
	ui.visible = true
	shop.visible = false
	if shop.equipGentle:
		currentHat = "gentle"
	elif shop.equipStraw:
		currentHat = "straw"
	elif shop.equipBass:
		currentHat = "bass"
	elif shop.equipFear:
		currentHat = "fear"
	else:
		currentHat = ""
		
	bebe_carrots = shop.bebes
	fishes = shop.fishes
	ui.update_bebes(bebe_carrots)
	ui.update_fishes(fishes)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	update_hat()
	
func entered_gerald():
	gerald = true

func leaving_gerald():
	gerald = false
	
func talked_to_gerald():
	ui.npc_bool = true
	canMove = false
	velocity = Vector3.ZERO
	if(gerald_prog == 2):
		ui.gerald4_scene = true
		ui._on_start_scene_gerald_4()
	elif(currentHat=="gentle"):
		ui.gerald3_scene = true
		ui._on_start_scene_gerald_3()
	elif(gerald_prog == 0):
		print("here")
		ui.gerald1_scene = true
		ui._on_start_scene_gerald_1()
	elif(gerald_prog == 1):
		ui.gerald2_scene = true
		ui._on_start_scene_gerald_2()
	
	$".."._on_user_interface_change_to_gerald()
	
func approaching_sign():
	sign = true
	
func leaving_sign():
	sign = false
	
func reading_sign():
	canMove = false
	velocity = Vector3.ZERO
	$"..".sign_camera_swap()
	ui.read_sign()
	ui.reading_sign = true
	
func approaching_larry():
	larry = true
	
func leaving_larry():
	larry = false
	
func talked_to_larry():
	if(!readyToFish):
		canMove = false
		velocity = Vector3.ZERO
		$".."._on_user_interface_change_to_larry()
		ui.start_larry1_scene()
		ui.larry1_scene = true
	
func approaching_fishing():
	fishing = true

func leaving_fishing():
	fishing = false

func opened_fishing():
	canMove = false
	velocity = Vector3.ZERO
	$".."._on_user_interface_change_to_fishing()


func _on_bg_finished():
	BG.play()

func entered_sean():
	sean = true
	
func leaving_sean():
	sean = false

func talk_to_sean():
	canMove = false
	velocity = Vector3.ZERO
	$"..".swap_to_sean()
	ui.talked_to_sean()
	ui.npc_bool = true
