extends Node3D

@onready var particles = $GPUParticles3D
@onready var timer = $Timer
@onready var audio = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	particles.emitting = false
	timer.start()


func _on_timer_timeout():
	if(particles.emitting):
		particles.emitting = false
		timer.wait_time = 20
	else:
		particles.emitting = true
		audio.play()
		timer.wait_time = 7
	timer.start()
	
