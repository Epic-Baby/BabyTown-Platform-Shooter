extends Node2D

const FiftyCal = preload("res://Weapons//Bullets//50BMG.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var MousePosition
var ShootEnable = false
var Loaded = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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

func _input(_event):
	if Input.is_action_just_pressed("Click") and ShootEnable and Loaded:
		$Sprite/CPUParticles2D.set("emitting",true)
		var b = FiftyCal.instance()
		owner.owner.add_child(b)
		b.transform = $Sprite/Position2D.global_transform
		Loaded = false
		$Reload.start()
	


func _on_Reload_timeout():
	Loaded = true

