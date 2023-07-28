extends Area3D

@export var rot_speed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.y += rot_speed * delta 
	pass

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	queue_free()
