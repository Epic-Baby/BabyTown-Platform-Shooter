extends CPUParticles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Damage = 120
var DoOnce = true


# Called when the node enters the scene tree for the first time.
func _ready():
	set("emitting",true)
	DoOnce = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#$Area2D/CollisionShape2D.set("radius", Radius)
	
	if Damage > 150 && DoOnce:
		$Area2D/CollisionShape2D.shape.set("radius", 60)
		set("lifetime", 0.35)
		set("amount", 2500)
		DoOnce = false


func _on_Timer_timeout():
	queue_free()



func _on_Explosion_body_entered(body):
	if body.is_in_group("BadGuys"):
		body.Health -= Damage
