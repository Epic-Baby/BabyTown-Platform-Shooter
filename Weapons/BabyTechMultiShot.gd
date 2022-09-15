extends Node2D

const ShotgunBullet = preload("res://Weapons//Bullets//ShotgunBullet.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var MousePosition
var ShootEnable = true
var Loaded = true
var BulletNumber = 6
var Random = RandomNumberGenerator.new()
var Position = Vector2()
var Cycled = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	MousePosition = get_global_mouse_position()
	look_at(MousePosition)
	if get_viewport_rect().size.x/2 > get_viewport().get_mouse_position().x:
		$Sprite.set("scale", Vector2(1,-1))
		$Sprite/Position2D.set("scale", Vector2(1,-1))
		$Sprite/HoldingPoint.set("scale", Vector2(1,-1))
		$Sprite/HoldingPoint2.set("scale", Vector2(1,-1))
	else:
		$Sprite.set("scale", Vector2(1,1))
		$Sprite/Position2D.set("scale", Vector2(1,1))
		$Sprite/HoldingPoint.set("scale", Vector2(1,1))
		$Sprite/HoldingPoint2.set("scale", Vector2(1,1))
	
	if BulletNumber < 1 and Loaded:
		Loaded = false
		$Reload.start()
		



	if Input.is_action_just_pressed("Click") and ShootEnable and Loaded and Cycled:
		$Sprite/CPUParticles2D.set("emitting",true)
		var b = [ShotgunBullet.instance(),ShotgunBullet.instance(),ShotgunBullet.instance(),ShotgunBullet.instance(),ShotgunBullet.instance(),ShotgunBullet.instance(),ShotgunBullet.instance()]

		for ShotsFired in 7:
			$Sprite/Position2D.set("rotation_degrees",Random.randf_range(-10, 10))
			owner.owner.add_child(b[ShotsFired])
			b[ShotsFired].transform = $Sprite/Position2D.global_transform
			
		BulletNumber -= 1
		Cycled = false
		$Timer.start()

		
func _on_Reload_timeout():
	BulletNumber = 6
	Loaded = true


func _on_Timer_timeout():
	Cycled = true
