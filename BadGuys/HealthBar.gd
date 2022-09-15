extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	Health = get_parent().Health
	
	set("rect_size", Vector2(Health, 8))
	set("rect_position",Vector2(-Health/2, -72))
	if Health > 50:
		color =  Color(float(1.0-(Health-50.0)/50.0), 1, 0, 1)

	else:
		color = Color(1, float(Health/50.0), 0, 1)

