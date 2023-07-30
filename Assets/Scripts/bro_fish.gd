extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at($"../Player/".position)
	rotation.y = rotation.y + deg_to_rad(90)
	rotation.z = clamp(rotation.z, 0, 0)
	rotation.x = clamp(rotation.x, 0, 0)
