extends Sprite

const Explosion = preload("res://Weapons//Bullets//Explosion.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 500

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta


func _on_Rocket_body_entered(_body):
	speed = 0
	var b = Explosion.instance()
	add_child(b)
	set("frame",15)
	$Exhaust.set("emitting",false)
	$Exhaust.set("visible",false)
	$Timer.start()



func _on_DeLagger_timeout():
	queue_free()


func _on_Timer_timeout():
	queue_free()
