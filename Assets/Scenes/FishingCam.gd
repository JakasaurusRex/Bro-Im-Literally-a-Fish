extends Camera3D

signal lost_fish_signal
signal scared_fish_signal
signal left_fishing

@export var line_rad = 0.01
@export var line_res = 10

@export var isFishing = true
@export var mouse_sens = 0.01

@onready var reel = $reel/Cylinder_002
@onready var timer = $FishTimer
@onready var bobber = $Bobber
@onready var bobber_anim = $Bobber/BobberAnimation

@export var total_rotation = 0
@export var total_spins = 0
@export var starting_rot = 0 
@export var starting_spins = 0 
@export var waiting_for_fish = false
@export var bobbed = false
@export var hooked = false
@export var scared_fish = false
@export var lost_fish = false

@onready var esc = $Esc_key
@onready var esc_text = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible and Input.is_action_just_pressed("esc"):
		emit_signal("left_fishing")
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if visible:
		if lost_fish:
			emit_signal("lost_fish_signal")
			visible = false
		elif scared_fish:
			emit_signal("scared_fish_signal")
			visible = false
	
	var circle = PackedVector2Array()
	for degree in line_res:
		line_rad = 0.03
		var x = line_rad * sin(PI * 2 * degree / line_res)
		var y = line_rad * cos(PI * 2 * degree / line_res)
		var coords = Vector2(x, y)
		circle.append(coords)
	$CSGPolygon3D.polygon = circle
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or Input.mouse_mode == Input.MOUSE_MODE_VISIBLE) and isFishing and visible == true:
		reel.rotate_y(deg_to_rad(-abs(event.relative.y) * mouse_sens))
		reel.rotate_y(deg_to_rad(-abs(event.relative.x) * mouse_sens))
		
		total_rotation = abs(rad_to_deg(reel.rotation.y))
		if(total_rotation >= 175):
			total_spins += 1
		if(total_spins >= 2 and waiting_for_fish):
			scared_fish = true



func _on_visibility_changed():
	total_rotation = 0
	total_spins = 0
	reel.rotation.y = 0
	if(visible == true):
		var rng = RandomNumberGenerator.new()
		var random_time = rng.randf_range(0.5, 5.7)
		timer.start(random_time)
		waiting_for_fish = true
		bobbed = false
		esc.visible = true
		esc_text.visible = true
		lost_fish = false
		scared_fish = false
	else:
		esc.visible = false
		esc_text.visible = false
		timer.stop()
	

func _on_fish_timer_timeout():
	if(visible == false):
		pass
	if(waiting_for_fish):
		waiting_for_fish = false
		bobber_anim.play("bob")
		timer.start(1.3)
		starting_rot = total_rotation
		starting_spins = total_spins
		bobbed = true
	elif(bobbed):
		if(total_rotation-starting_rot>=90 or total_spins > starting_spins):
			hooked = true
			bobbed = false
		else:
			lost_fish = true
		
