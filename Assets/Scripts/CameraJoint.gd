extends SpringArm3D

@export var mouseSensitivity = 0.005


# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var tempRot = rotation.x - event.relative.y * mouseSensitivity
		rotation.y -= event.relative.x * mouseSensitivity
		tempRot = clamp(tempRot, -1, 0.25)
		rotation.x  = tempRot
		
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


