extends Node3D

@export var isSatisfied = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("shake")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at($"../Player/".position)
	rotation.y = rotation.y + deg_to_rad(90)
	rotation.z = clamp(rotation.z, 0, 0)
	rotation.x = clamp(rotation.x, 0, 0)


func _on_animation_player_animation_finished(anim_name):
	if(!isSatisfied):
		$AnimationPlayer.play("shake")
		



func _on_user_interface_show_carrot():
	isSatisfied = true
