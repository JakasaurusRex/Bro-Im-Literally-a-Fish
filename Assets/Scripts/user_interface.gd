extends Control

signal transitioned
signal over
signal change_to_bro
signal change_to_feesh
signal change_to_gerald
signal show_carrot
signal change_to_larry
signal spawn_larry
signal change_to_sean
signal show_sean
signal explosion_time

@onready var textrect = $ColorRect2
@onready var textbox = $ColorRect2/RichTextLabel
@onready var player = $"../Player"
var bro_fish1 = ["Bro I'm literally a fish", "bro", "bro", "why is there a fire underwater", "i dunno", "go back to collecting carrots bro so you can get us outta here"]
var bro_fish1_index = 0

var gerald1 = ["I dont talk to poor fish", "You just talked to me right now", "Oh" ,"You did it again", "Go away", "Is that a monocle made out of a soda can ring",  "No its pure gold, I bought it with this fat stack of american dollars", "We are fish... who uses dollars down here", "Don't worry about it...", "I thought you don't talk to poor fish", "...", "..."]
var gerald1_index = 0

var gerald3 = ["Why hello fellow gentlefish", "Bro...", "I have been trying to eat this carrot for 3 hours but I forgot I have no teeth, would you be able to eat it for me?", "Oge", "Why thank you sire"]
var gerald3_index = 0

var signText = ["To reach a plane of higher grace, Four carrots hold the path in place. In each, a test of soul and might, To evolve beyond mortal sight.", "The first, a hat in every hue, Collect them all, let none eschew. Embrace diversity's attire, Unite the realms, stoke love's fire.", "The second carrot, challenge stern, Help one who's spurned, from lessons learn. To aid the undeserving soul, Forgiveness finds its sacred role.", "The third, a race against the sun, The fastest stride, the race is won. Yet humbly share your winning glee, In victory, find unity.", "The final carrot, veiled in haze, Achieve the impossible, amaze. In feats that break the limits known, A higher being's seed is sown.", "So heed my word, dear seeker brave, These carrots four, your essence crave. Evolve and rise, let love be stirred, To heights unknown, collect each word. ", "Upon fate's precipice, a volcano's rage, Its fiery breath ties life's turning page. Within its depths, transformation's stage, Evolve with purpose, a higher level engage."]
var signIndex = 0

var sean_text = ["Hello!", "Hi, you seem normal", "Well unfortunately, the person who put me in this tank ran out of time and wanted to go to sleep", "Ah thats fair, what were you gonna do", "I was gonna have you race me to the furthest place up from the bottom and then I would have given you this carrot.", "Oh nice, can I have it", "Yea go for it, thanks for playing the game!"]
var sean_index = 0
var sean_scene = false
var beat_game = false

@export var npc_bool = false
@export var pond_scene = false
@export var reading_sign = false

@export var gerald1_scene = false
@export var gerald2_scene = false
@export var gerald3_scene = false
@export var gerald4_scene = false

@export var larry1_scene = false

@export var first_catch = true
@export var volcano = false

var larry1_text = ["Hey kid, are ye lookin to fish?", "Aren't we underwater", "Ye what abouts that", "Nevermind...", "Have my spare rod I have. All ya hafta do is walk up to my dock over here, cast your rod and wait for a bite.", "What is gonna bite the hook", "Once you have a bite yer gonna wanna reel er in with the crank, make sure to reel the same speed as the fish or you'll lose em", "Wait I'm catching fish", "If you have any questions, I can't answer them but bring me yer haul and I'll give you a couple bebe carrots for them", "Yarp"]
var larry1_index = 0
var caught_fish = false
var saw_legs

@export var messed_up_fish = false

@onready var interaction_label = $"Interaction Label"
@onready var larryAnim = $"../Larry/AnimationPlayer"
@onready var talking_sfx = $talking
@onready var glub_sfx = $glubglub

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = false
	$ColorRect.color = Color(0, 0, 0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if textrect.visible and Input.is_action_just_pressed("back"):
		if(caught_fish):
			talking_sfx.play()
			if(first_catch):
				first()
				return
			caught_fish = false
			player.bebe_carrots += 8
			update_bebes(player.bebe_carrots)
			emit_signal("over")
			return
	if textrect.visible and Input.is_action_just_pressed("enter"):
		if(saw_legs):
			saw_legs = false
			emit_signal("over")
			return
		if(caught_fish):
			talking_sfx.play()
			if(first_catch):
				first()
				return
			caught_fish = false
			player.fishes += 1
			update_fishes(player.fishes)
			emit_signal("over")
			return
		if(messed_up_fish):
			messed_up_fish = false
			talking_sfx.play()
			emit_signal("over")
			return
		if(pond_scene):
			pond_scene = false
			talking_sfx.play()
			emit_signal("over")
			return
		if(reading_sign):
			signIndex+=1
			read_sign()
			return
		if(gerald2_scene):
			gerald2_scene = false
			emit_signal("over")
			talking_sfx.play()
			return
		if(gerald4_scene):
			gerald4_scene = false
			emit_signal("over")
			talking_sfx.play()
			return
		if npc_bool == true:
			glub_sfx.play()
			npc_bool = false
			emit_signal("change_to_feesh")
			if larry1_scene:
				start_larry1_scene()
				larry1_index+=1
				return
			if sean_scene:
				sean_index+=1
				talked_to_sean()
				return
			if gerald1_scene:
				_on_start_scene_gerald_1()
				gerald1_index+=1
				return
			elif gerald3_scene:
				_on_start_scene_gerald_3()
				gerald3_index+=1
				return
		elif larry1_scene:
			npc_bool = true
			emit_signal("change_to_larry")
			talking_sfx.play()
			start_larry1_scene()
			larry1_index+=1
			return
		elif sean_scene:
			npc_bool = true
			emit_signal("change_to_sean")
			talking_sfx.play()
			sean_index+=1
			talked_to_sean()
			return
		elif gerald1_scene:
			npc_bool = true
			emit_signal("change_to_gerald")
			talking_sfx.play()
			_on_start_scene_gerald_1()
			gerald1_index+=1
			return
		elif gerald3_scene:
			npc_bool = true
			emit_signal("change_to_gerald")
			_on_start_scene_gerald_3()
			talking_sfx.play()
			gerald3_index+=1
			return
		else:
			npc_bool = true
			emit_signal("change_to_bro")
		talking_sfx.play()
		bro_fish1_index+=1
		_on_start_scene_bro_fish_1()

func update_bebes(carrots):
	if carrots >= 100:
		$bebeCarrotLeftNum.frame = carrots / 100
		$bebeCarrotMiddleNum.frame = carrots % 100 / 10
		$bebeCarrotRightNum.frame = carrots % 100 % 10
	elif carrots >= 10:
		$bebeCarrotLeftNum.frame = 0
		$bebeCarrotMiddleNum.frame = carrots / 10
		$bebeCarrotRightNum.frame = carrots % 10
	else:
		$bebeCarrotLeftNum.frame = 0
		$bebeCarrotMiddleNum.frame = 0
		$bebeCarrotRightNum.frame = carrots % 10

func update_carots(carrots):
	if carrots >= 10:
		$carrotLeftNum.frame = carrots / 10
		$carrotRightNum.frame = carrots % 10
	else:
		$carrotLeftNum.frame = 0
		$carrotRightNum.frame = carrots % 10

func update_fishes(fishes):
	if fishes >= 100:
		$fishLeftNum.frame = fishes / 100
		$fishMiddleNum.frame = fishes % 100 / 10
		$fishRightNum.frame = fishes % 100 % 10
	elif fishes >= 10:
		$fishLeftNum.frame = 0
		$fishMiddleNum.frame = fishes / 10
		$fishRightNum.frame = fishes % 10
	else:
		$fishLeftNum.frame = 0
		$fishMiddleNum.frame = 0
		$fishRightNum.frame = fishes % 10

func transition():
	print("transitioning")
	$ColorRect.visible = true
	$AnimationPlayer.play("fade_to_black")

func _on_animation_player_animation_finished(anim_name):
	print("finished")
	if(beat_game):
		pass
	if(volcano and anim_name == "fade_to_black"):
		$AnimationPlayer.play("fade_to_normal")
		return
	elif(volcano):
		emit_signal("explosion_time")
		return
	if(anim_name == "fade_to_black"):
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_normal")
	if(anim_name == "fade_to_normal"):
		$ColorRect.visible = false


	
func _on_start_scene_bro_fish_1():
	if bro_fish1_index >= bro_fish1.size():
		emit_signal("over")
		return
	textrect.visible = true
	textbox.clear()
	textbox.add_text(bro_fish1[bro_fish1_index])

func pond():
	textrect.visible = true
	textbox.clear()
	textbox.add_text("fish can't swim bro")
	
func interaction():
	interaction_label.visible = true
	
func leaving_interaction():
	interaction_label.visible = false

func _on_start_scene_gerald_1():
	if gerald1_index >= gerald1.size():
		gerald1_scene = false
		emit_signal("over")
		return
	textrect.visible = true
	textbox.clear()
	textbox.add_text(gerald1[gerald1_index])
	
func _on_start_scene_gerald_2():
	textrect.visible = true
	textbox.clear()
	textbox.add_text("...")
	
func _on_start_scene_gerald_3():
	if gerald3_index == 2:
		emit_signal("show_carrot")
	if gerald3_index >= gerald3.size():
		gerald3_scene = false
		emit_signal("over")
		return
	textrect.visible = true
	textbox.clear()
	textbox.add_text(gerald3[gerald3_index])
	
func _on_start_scene_gerald_4():
	textrect.visible = true
	textbox.clear()
	textbox.add_text("Thank you for all the help sire")
	
func read_sign():
	if signIndex >= signText.size():
		reading_sign = false
		signIndex = 0
		emit_signal("over")
		return
	textrect.visible = true
	textbox.clear()
	textbox.add_text(signText[signIndex])
	
func start_larry1_scene():
	if larry1_index >= larry1_text.size():
		larry1_scene = false
		emit_signal("over")
		return
	textrect.visible = true
	textbox.clear()
	textbox.add_text(larry1_text[larry1_index])

func lost_fish():
	messed_up_fish = true
	textrect.visible = true
	textbox.clear()
	textbox.add_text("Ya lost da fish, try reelin in when you see da bobber go down and get that hook in")

func scared_fish():
	messed_up_fish = true
	textrect.visible = true
	textbox.clear()
	textbox.add_text("Ya scared da fish, only start reely reeling when you get the fish on the hook or it'll scram")
	
func fish_too_fast():
	messed_up_fish = true
	textrect.visible = true
	textbox.clear()
	textbox.add_text("Ya lost da fish, try crankin the reel the same speed as the fish")
	
func nice_catch():
	caught_fish = true
	textrect.visible = true
	textbox.clear()
	textbox.add_text("Nice catch kiddo, you can keep the fish, or sell it to me for 8 bebe carrots, I'm a little hungry (s to sell, enter to keep)")

func first():
	first_catch = false
	caught_fish = true
	textrect.visible = true
	textbox.clear()
	textbox.add_text("As a reward for your first catch, I'll give ya this backscratcher I have been using. Use it well")
	larryAnim.play("turn")
	emit_signal("spawn_larry")
	
func talked_to_sean():
	sean_scene = true
	if sean_index == 5:
		emit_signal("show_sean")
	if sean_index >= sean_text.size():
		sean_scene = false
		emit_signal("over")
		return
	textrect.visible = true
	textbox.clear()
	textbox.add_text(sean_text[sean_index])
	
func leg_scene():
	glub_sfx.play()
	saw_legs = true
	textrect.visible = true
	textbox.clear()
	textbox.add_text("I feel different... OH MY GOD ARE THOSE HUMAN LEGS... I EVOLVED")
