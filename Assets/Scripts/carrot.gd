extends Area3D

@export var rot_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.y += rot_speed * delta 
	pass

