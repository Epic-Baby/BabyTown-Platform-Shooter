extends Line2D

export var length = 10
var point = Vector2()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
		#Fill point buffer with get parent global position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	global_position = Vector2(0,0)
	global_rotation = 0
	point = get_parent().global_position
	
	add_point(point)
	while get_point_count() > length:
		remove_point(0)

