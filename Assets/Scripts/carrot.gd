extends Area3D

@export var rot_speed = 5
#@export var starting_pos = Vector3(6, 6, 6)
#@export var scaley = Vector3(6, 6, 6)
var feesh

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true
	#scale = scaley
	#position = starting_pos
	print(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.y += rot_speed * delta 

func animate():
	print(position)
	$"AnimationPlayer".play("shrink")

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("poop")
	feesh = body
	feesh.eat_carrot(self)


func _on_animation_player_animation_finished(anim_name):
	feesh.done_eating()
	queue_free()
