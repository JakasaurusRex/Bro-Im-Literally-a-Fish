extends CharacterBody3D

@export var speed = 10.0
@export var jumpStrength = 20.0
@export var gravity = -50.0
@export var acceleration = 70
@export var friction = 60 
@export var air_fric = 10
@export var mouse_sens = 0.1
@export var rot_speed = 15

@onready var _springArm = $SpringArm
@onready var pivot = $Pivot
var _snapVector = Vector3.ZERO


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
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
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	return input_vector.normalized() if input_vector.length() > 1  else input_vector
	
func get_direction(input_vector):
	var direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	

func apply_friction(input_direction, delta):
	if input_direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(input_direction * speed, air_fric * delta).x
			velocity.z = velocity.move_toward(input_direction * speed, air_fric * delta).z

func apply_movement(input_vector, direction, delta):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * speed, acceleration * delta).z
		# pivot.look_at(global_transform.origin + direction, Vector3.UP)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-input_vector.x, -input_vector.z), rot_speed * delta)
		
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jumpStrength)
	
	
func jump():
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jumpStrength
		elif Input.is_action_just_released("jump") and velocity.y > jumpStrength/2:
			velocity.y = jumpStrength/2
		
