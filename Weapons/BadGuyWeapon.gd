extends Node2D

const Bullet = preload("res://Weapons/Bullets/BadGuyBullet.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var WeaponType = 2
var Damage = 0
var Inaccuracy = 0
var Init = false
var Loaded = true
var Fire = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(_delta):
	if Init:
		if WeaponType == 0:
			$Sprite.set("position",Vector2(3,0))
			$Sprite.set("frame",0)
			$Sprite/Position2D.set("position",Vector2(13,-4))
			$Timer.set("wait_time",0.75)
			Damage = 10
			Inaccuracy = 25
		elif WeaponType == 1:
			$Sprite.set("position",Vector2(8,0))
			$Sprite.set("frame",1)
			$Sprite/Position2D.set("position",Vector2(45,-4))
			$Timer.set("wait_time",2)
			Damage = 20
			Inaccuracy = 10
		elif WeaponType == 2:
			$Sprite.set("position",Vector2(8,0))
			$Sprite.set("frame",2)
			$Sprite/Position2D.set("position",Vector2(45,-4))
			$Timer.set("wait_time",0.25)
			Damage = 15
			Inaccuracy = 20
		else:
			$Sprite.set("position",Vector2(8,-1))
			$Sprite.set("frame",3)
			$Sprite/Position2D.set("position",Vector2(45,-5))
			$Timer.set("wait_time",5)
			Damage = 5
			Inaccuracy = 30
		Init = false
	
	
	if Fire:
		Fire = false
		$Timer.start()
		Loaded = false


#	pass


func _on_Timer_timeout():
	Loaded = true
