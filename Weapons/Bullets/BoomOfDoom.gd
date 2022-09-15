extends Node2D

const Explosion = preload("res://Weapons//Bullets//Explosion.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 850
var CurrentYVelocity = 0
var Angle = 0
var Velocity = Vector2(0,0)
var GlobalAngle = 0
var Flying = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Flying:
		CurrentYVelocity += 19.6 * 60 * delta
		Velocity = transform.x * speed + Vector2(0, CurrentYVelocity)
		position += Velocity * delta
		GlobalAngle = rad2deg(transform.x.angle())
		Angle = rad2deg(Velocity.angle())#rad2deg(Velocity.angle())
		$Sprite.set("rotation_degrees", Angle - GlobalAngle)
	
	
func _on_DeLagger_timeout():
	queue_free()


func _on_Area2D_body_entered(_body):
	Flying = false
	var b = Explosion.instance()
	call_deferred("add_child", b)
	b.Damage = 200
	$Sprite/Area2D.set_deferred("monitoring",false)
	$Sprite.set("frame",1)
	$Sprite/SmokeTrail.set("emitting",false)
	$Sprite/SmokeTrail.set("visible",false)
	$Timer.start()



func _on_Timer_timeout():
	queue_free()
