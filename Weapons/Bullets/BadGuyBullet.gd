extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 1000
var damage = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	$Trail.set("width",1+speed/250)
	$Hit/CollisionShape2D.set("extents", Vector2(speed/60,1))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	$Hit.set("angular_damp", damage)

func _on_Hit_body_entered(body):
	if !body.is_in_group("BadGuys"):
		queue_free()


func _on_DeLagger_timeout():
	queue_free()
