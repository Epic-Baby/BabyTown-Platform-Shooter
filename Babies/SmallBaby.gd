extends KinematicBody2D


#const BigShot = preload("res://Weapons//BigShot.tscn")
#const BiggerShot = preload("res://Weapons//BiggerShot.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float, 0, 1.0) var friction = 0.15
export (float, 0, 1.0) var acceleration = 0.5
var velocity = Vector2()
var speed = 150
var dir = 0
var AnimPlayer
var MousePosition
var Head
var TopHand
var BottomHand
var HoldingPointTwo
var HoldingPointTwoLocation = Vector2()
var WeaponNumber = 1
var WeaponSelect = "BigShot"
var NewWeapon = true
var HitPoints = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	AnimPlayer = $AnimationPlayer
	Head = $Head
	TopHand = $TopHand
	BottomHand = $BottomHand
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#warning-ignore:unused_argument
func _process(delta):
	MousePosition = get_global_mouse_position()
	$TopHand.look_at(MousePosition)
	if NewWeapon:

		$TopHand/BabyTech9.set("ShootEnable",false)
		$TopHand/BabyTech9.set("visible",false)
		$TopHand/BabyTech9X.set("ShootEnable",false)
		$TopHand/BabyTech9X.set("visible",false)
		$TopHand/Dagger.set("visible",false)
		match WeaponNumber:#Use WeaponNumber here?
			0: #Dagger
				HoldingPointTwo = $TopHand/Dagger/Sprite/HoldingPoint2
				$TopHand/Dagger.set("visible",true)
			
			
			1:#"BT9":
				pass
				HoldingPointTwo = $TopHand/BabyTech9/Sprite/HoldingPoint2
				$TopHand/BabyTech9.set("ShootEnable",true)
				$TopHand/BabyTech9.set("visible",true)
				$TopHand/BabyTech9.set("ShootEnable",true)
			2:#"BT9x":
				pass
				HoldingPointTwo = $TopHand/BabyTech9X/Sprite/HoldingPoint2
				$TopHand/BabyTech9X.set("ShootEnable",true)
				$TopHand/BabyTech9X.set("visible",true)
				$TopHand/BabyTech9X.set("ShootEnable",true)
			_:
				print("ERROR!")

		NewWeapon = false



	HoldingPointTwoLocation = HoldingPointTwo.global_transform.origin


	BottomHand.look_at(HoldingPointTwoLocation)


	
	
	Head.look_at(MousePosition)
	if position.x > MousePosition.x:
		Head.set("flip_v", true)
		$TopHand/Dagger.set("scale",Vector2(1,-1))
		$TopHand/Dagger.set("position",Vector2(9,2))
	else:
		Head.set("flip_v", false)
		$TopHand/Dagger.set("scale",Vector2(1,1))
		$TopHand/Dagger.set("position",Vector2(9,-2))
		
func _input(_event):
########## Weapon Selection #################
	if Input.is_action_just_pressed("Scroll_Up"):
		NewWeapon = true
		WeaponNumber += 1
	if Input.is_action_just_pressed("Scroll_Down"):
		NewWeapon = true
		WeaponNumber -= 1
	if WeaponNumber == 3:
		WeaponNumber = 0
	if WeaponNumber == -1:
		WeaponNumber = 2

	if Input.is_action_just_pressed("Click") && WeaponNumber == 0:
		$TopHand/Dagger.set("rotation_degrees", 60 * $TopHand/Dagger.get("scale").y)
		$TopHand/Dagger/Area2D.set("monitoring", true)
		$TopHand/Dagger/Timer.start()

func _physics_process(delta):

	dir = 0
	if Input.is_action_pressed('ui_right'):
		dir += 1
	if Input.is_action_pressed('ui_left'):
		dir -= 1
		
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		AnimPlayer.set_current_animation("Walk")
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		AnimPlayer.set_current_animation("Stationary")
	
	if is_on_floor() and Input.is_action_pressed('ui_up'):
		velocity.y = -562.5
	
	velocity.y += 1000 * delta
	velocity = move_and_slide(velocity, Vector2(0,-1))

#Speed = 750, Jump = 562.5 (750 * 0.75)


func _on_Area2D_body_entered(body):
	if body.is_in_group("BadGuys"):
		body.Health -= 30
	$TopHand/Dagger.set("rotation_degrees",0)
	


func _on_DaggerTimer_timeout():
	$TopHand/Dagger.set("rotation_degrees",0)
	$TopHand/Dagger/Area2D.set("monitoring", false)



func _on_Area2D_area_entered(area):
	if area.is_in_group("BadGuyBullets"):
		HitPoints -= area.angular_damp
		print(HitPoints)

