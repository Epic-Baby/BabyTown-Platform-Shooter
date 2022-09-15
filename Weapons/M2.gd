extends Node2D

const FiftyCaliber = preload("res://Weapons//Bullets//50BMG.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var MousePosition
var ShootEnable = true
var Loaded = true
var BulletNumber = 50
var Random = RandomNumberGenerator.new()
var Cycled = true
var Position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	Position = $Sprite.get("position")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	MousePosition = get_global_mouse_position()
	
	if get_viewport_rect().size.x/2 > get_viewport().get_mouse_position().x:
		$Sprite.set("scale", Vector2(1,-1))
		$Sprite.set("position", Vector2(Position.x, Position.y-50))
		$Sprite/Position2D.set("scale", Vector2(1,-1))
		$Sprite/HoldingPoint.set("scale", Vector2(1,-1))
		$Sprite/HoldingPoint2.set("scale", Vector2(1,-1))
		look_at(MousePosition - Vector2(-24,25))
	else:
		$Sprite.set("scale", Vector2(1,1))
		$Sprite.set("position", Position)
		$Sprite/Position2D.set("scale", Vector2(1,1))
		$Sprite/HoldingPoint.set("scale", Vector2(1,1))
		$Sprite/HoldingPoint2.set("scale", Vector2(1,1))
		look_at(MousePosition - Vector2(24,25))
	
	if BulletNumber < 1 and Loaded:
		Loaded = false
		$Reload.start()




	if Input.is_action_pressed("Click") and ShootEnable and Loaded and Cycled:
		$Sprite/Position2D.set("rotation_degrees",Random.randf_range(-1, 1))
		$Sprite/CPUParticles2D.set("emitting",true)
		var b = FiftyCaliber.instance()
		owner.owner.add_child(b)
		b.transform = $Sprite/Position2D.global_transform
		BulletNumber -= 1
		Cycled = false
		$Timer.start()


func _on_Timer_timeout():
	Cycled = true


func _on_Reload_timeout():
	BulletNumber = 50
	Loaded = true
