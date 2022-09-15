extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 1500

# Called when the node enters the scene tree for the first time.
func _ready():
	$Trail.set("width",8)#Width of bullet (px) + speed : 250


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta


func _on_50BMG_body_entered(body):
	if body.is_in_group("BadGuys"):
		body.Health -= 50
	queue_free()


func _on_DeLagger_timeout():
	queue_free()
