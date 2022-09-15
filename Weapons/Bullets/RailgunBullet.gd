extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 2000
var TrailPoint = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta

	$Trail.global_position = Vector2(0,0)
	$Trail.global_rotation = 0
	TrailPoint = $Trail.get_parent().global_position

	$Trail.add_point(TrailPoint)
	while $Trail.get_point_count() > 20:
		$Trail.remove_point(0)



func _on_DeLagger_timeout():
	queue_free()


func _on_RailGunBullet_body_entered(body):
	if body.is_in_group("BadGuys"):
		body.Health -= 40
