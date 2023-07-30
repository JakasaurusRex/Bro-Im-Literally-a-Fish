@tool
extends Camera3D

@export var line_rad = 0.01
@export var line_res = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var circle = PackedVector2Array()
	for degree in line_res:
		line_rad = 0.03
		var x = line_rad * sin(PI * 2 * degree / line_res)
		var y = line_rad * cos(PI * 2 * degree / line_res)
		var coords = Vector2(x, y)
		circle.append(coords)
	$CSGPolygon3D.polygon = circle
