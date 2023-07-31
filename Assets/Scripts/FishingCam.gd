extends Camera3D

signal lost_fish_signal
signal scared_fish_signal
signal left_fishing
signal caught_fish
signal fish_too_fast

@export var line_rad = 0.01
@export var line_res = 10

@export var isFishing = true
@export var mouse_sens = 0.3

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
@export var on_hook = false
@export var scared_fish = false
@export var lost_fish = false

@onready var esc = $Esc_key
@onready var esc_text = $RichTextLabel

@onready var gauge = $"Fishing Gauge"
@onready var completion_left = $"Fishing Gauge/completion_left"
@onready var completion_mid = $"Fishing Gauge/completion_middle"
@onready var completion_right = $"Fishing Gauge/completion_right"
@onready var num = $"Fishing Gauge/Num"
@onready var speed_text = $"Fishing Gauge/Speed"

@onready var viewport = $"You caught/Viewport"
@onready var you_caught = $"You caught"
@onready var fish = $"You caught/Viewport/fish"
@onready var fish_sprite = $"You caught/Sprite2D"
@onready var reeling_sfx = $Reeling
@onready var reeling_done = $"Finished Reeling"
@onready var nice_catch_sfx = $niceCatch
@onready var fishingbg = $fishingbg

var crank_time = 0
var crank_amount = 0
var spin_start_time = 0
var spin_cur_time = 0
var completed = 0
var spinThisRot = false
var on_caught = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_caught and Input.is_action_just_pressed("enter"):
			emit_signal("caught_fish")
			print("here")
			visible = false
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
		if(on_hook):
			spin_cur_time = Time.get_ticks_msec()/1000.0
			var time_elapsed = spin_cur_time - spin_start_time
			var spins = total_spins-starting_spins + total_rotation/180
			print("spins " + str(spins))
			print("time_elapsed " + str(time_elapsed))
			speed_text.clear()
			speed_text.add_text(str(spins/time_elapsed).pad_decimals(1))
			if(time_elapsed >= crank_time):
				completed += 1
				update_gauge()
			elif(time_elapsed > 4.0 and ((spins < (crank_amount * 0.75 * time_elapsed)) or (spins > (crank_amount * 1.5 * time_elapsed)))):
				emit_signal("fish_too_fast")
				visible = false
		elif(on_caught):
			fish.rotation.y += deg_to_rad(1)
			
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
		
	
		if(rad_to_deg(reel.rotation.y) < 0):
			total_rotation = 180 + abs(rad_to_deg(reel.rotation.y))
		else:
			total_rotation = abs(rad_to_deg(reel.rotation.y))
		print(total_rotation)
		if(spinThisRot == false and total_rotation >= 345):
			total_spins += 1
			total_rotation = 0
			spinThisRot = true
		elif(total_rotation < 180):
			spinThisRot = false
			
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
		reeling_sfx.play()
		fishingbg.play()
	else:
		esc.visible = false
		esc_text.visible = false
		gauge.visible = false
		timer.stop()
		on_hook = false
		completion_left.frame = 1
		completion_mid.frame = 1
		completion_right.frame = 1
		completed = 0
		fish.visible = false
		you_caught.visible = false
		on_caught = false
		reeling_sfx.stop()
		reeling_done.stop()
		fishingbg.stop()

func _on_fish_timer_timeout():
	if(visible == false):
		pass
	if(waiting_for_fish):
		waiting_for_fish = false
		bobber_anim.play("bob")
		timer.start(1.7)
		starting_rot = total_rotation
		starting_spins = total_spins
		bobbed = true
	elif(bobbed):
		if(total_rotation-starting_rot>=90 or total_spins > starting_spins):
			hooked()
			bobbed = false
		else:
			lost_fish = true

func hooked():
	gauge.visible = true
	on_hook = true
	var rng = RandomNumberGenerator.new()
	var random_crank = rng.randi_range(1, 3)
	
	crank_time = rng.randi_range(4, 7)
	if(random_crank == 3 and crank_time >= 5):
		crank_time -= 1
	
	crank_amount = random_crank
	starting_spins = total_spins
	
	num.frame = crank_amount
	
	spin_start_time = Time.get_ticks_msec()/1000.0

func update_gauge():
	if(completed == 1):
		completion_left.frame = 0
		hooked()
	elif completed == 2:
		completion_mid.frame = 0
		hooked()
	elif completed == 3:
		completion_right.frame = 0
		caught()
		on_caught = true
		on_hook = false

func caught():
	reeling_sfx.stop()
	reeling_done.play()
	nice_catch_sfx.play()
	on_hook = false
	fish.visible = true
	you_caught.visible = true
	fish_sprite.texture = viewport.get_texture()
	


func _on_reeling_finished():
	if(!on_caught):
		reeling_sfx.play()


func _on_fishingbg_finished():
	fishingbg.play()
