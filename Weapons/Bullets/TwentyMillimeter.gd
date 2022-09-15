extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 2500
var HitObject = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Trail.set("width",13)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta


func _on_20Mil_body_entered(body):
	if body.is_in_group("BadGuys"):
		if !HitObject:
			body.Health -= 100
			HitObject = true
		else:
			body.Health -= 60
			queue_free()
	else:
		queue_free()


func _on_DeLagger_timeout():
	queue_free()



