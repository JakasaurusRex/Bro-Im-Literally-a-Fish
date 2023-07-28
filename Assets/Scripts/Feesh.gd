extends CharacterBody3D

signal pond 

@export var speed = 10.0
@export var jumpStrength = 30.0
@export var gravity = -50.0
@export var acceleration = 70
@export var friction = 100 
@export var air_fric = 10
@export var mouse_sens = 0.1
@export var rot_speed = 15
@export var bebe_carrots = 0
@export var startingPos = Vector3(429.853, 14.103, 465.986)

@onready var _springArm = $SpringArm
@onready var pivot = $Pivot
var _snapVector = Vector3.ZERO
@onready var canMove = true


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and canMove:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		_springArm.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		_springArm.rotation.x = clamp(_springArm.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	
func _physics_process(delta):
	if Input.is_action_just_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(input_vector, direction, delta)
	apply_gravity(delta)
	apply_friction(direction, delta)
	jump()
	move_and_slide()
	
	
func get_input_vector():
	if !canMove:
		pass
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	return input_vector.normalized() if input_vector.length() > 1  else input_vector
	
func get_direction(input_vector):
	if !canMove:
		pass
	var direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	

func apply_friction(input_direction, delta):
	if !canMove:
		pass
	if input_direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(input_direction * speed, air_fric * delta).x
			velocity.z = velocity.move_toward(input_direction * speed, air_fric * delta).z

func apply_movement(input_vector, direction, delta):
	if !canMove:
		pass
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * speed, acceleration * delta).z
		# pivot.look_at(global_transform.origin + direction, Vector3.UP)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-input_vector.x, -input_vector.z), rot_speed * delta)
		
func apply_gravity(delta):
	if !canMove:
		pass
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jumpStrength)
	
	
func jump():
	if !canMove:
		pass
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jumpStrength
		elif Input.is_action_just_released("jump") and velocity.y > jumpStrength/2:
			velocity.y = jumpStrength/2

		


func _on_bebe_carrot_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	bebe_carrots += 1
	$"../UserInterface".update_bebes(bebe_carrots)
	

func entered_pond(body_rid, body, body_shape_index, local_shape_index):
	print("entered pond")
	$"../UserInterface".transition()
	canMove = false


func _on_user_interface_transitioned():
	position = startingPos
	canMove = true
	emit_signal("pond")
