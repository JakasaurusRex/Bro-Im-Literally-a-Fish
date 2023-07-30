extends Control

signal all_hats

@export var ownGentle = true
@export var ownStraw = true
@export var ownBass = true
@export var ownFear = true

@onready var gentleButton = $Items/Gentle/Button
@onready var strawButton = $Items/Straw/Button
@onready var bassButton = $Items/Bass/Button
@onready var fearButton = $Items/Fear/Button

@onready var textbox = $TextRect/TextBox
@onready var timer = $Timer
@export var equipGentle = false
@export var equipStraw = false
@export var equipBass = false
@export var equipFear = false 

@export var bebes = 0
@export var fishes = 0

var seen_cutscene = false

# Called when the node enters the scene tree for the first time.
func _ready():
	textbox.text = "Welcome to my hat shop!"

func entered():
	textbox.text = "Welcome to my hat shop!"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(visible and !seen_cutscene and (ownGentle and ownBass and ownStraw and ownFear)):
		emit_signal("all_hats")
		seen_cutscene = true
		timer.start(1.7)
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return
	if ownGentle and not equipGentle:
		gentleButton.text = "Equip"
	elif ownGentle:
		gentleButton.text = "Unequip"
	else:
		gentleButton.text = "Buy"
		
	if ownStraw and not equipStraw:
		strawButton.text = "Equip"
	elif ownStraw:
		strawButton.text = "Unequip"
	else:
		strawButton.text = "Buy"
		
	if ownBass and not equipBass:
		bassButton.text = "Equip"
	elif ownBass:
		bassButton.text = "Unequip"
	else:
		bassButton.text = "Buy"
		
	if ownFear and not equipFear:
		fearButton.text = "Equip"
	elif ownFear:
		fearButton.text = "Unequip"
	else:
		fearButton.text = "Buy"
		

func gentle_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if !ownGentle:
		if bebes >= 20:
			ownGentle = true
			bebes -= 20
		else:
			textbox.clear()
			textbox.add_text("You're broke, go get me some more bebe carrots")
	elif ownGentle and !equipGentle:
		equipGentle = true
		equipStraw = false
		equipBass = false
		equipFear = false
	elif ownGentle and equipGentle:
		equipGentle = false
		
		

func straw_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if !ownStraw:
		if bebes >= 32:
			ownStraw = true
			bebes -= 32
		else:
			textbox.clear()
			textbox.add_text("Thoust are unfit to be king")
	elif ownStraw and !equipStraw:
		equipGentle = false
		equipStraw = true
		equipBass = false
		equipFear = false
	elif ownStraw and equipStraw:
		equipStraw = false
		
		



func bass_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if !ownBass:
		if bebes >= 10:
			ownBass = true
			bebes -= 10
		else:
			textbox.clear()
			textbox.add_text("Yer not a true pro, ya need more bebe carrots")
	elif ownBass and !equipBass:
		equipGentle = false
		equipStraw = false
		equipBass = true
		equipFear = false
	elif ownBass and equipBass:
		equipBass = false


func fear_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if !ownFear:
		if fishes >= 5:
			fishes -= 5
			ownFear = true
		else:
			textbox.clear()
			textbox.add_text("You are not loved or feared just yet, go catch some more fish")
	elif ownFear and !equipFear:
		equipGentle = false
		equipStraw = false
		equipBass = false
		equipFear = true
	elif ownFear and equipFear:
		equipFear = false


func _on_timer_timeout():
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	textbox.clear()
	textbox.add_text("You have conquered all of the realms of our world, in return I offer this keepsake I have.")
