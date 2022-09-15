extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	$Trail.set("width",5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		position += transform.x * speed * delta


func _on_ShotgunBullet_body_entered(body):
	if body.is_in_group("BadGuys"):
		body.Health -= 15
	queue_free()


func _on_DeLagger_timeout():
	queue_free()
