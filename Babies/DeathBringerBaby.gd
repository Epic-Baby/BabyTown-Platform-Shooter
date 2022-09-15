extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float, 0, 1.0) var friction = 0.15
export (float, 0, 1.0) var acceleration = 0.5
var velocity = Vector2()
var speed = 250
var dir = 0
var AnimPlayer
var MousePosition = Vector2()
var Head
var BulletType
var TopHand
var BottomHand
var HoldingPointTwo
var HoldingPointOne
var HoldingPointOneLocation = Vector2()
var HoldingPointTwoLocation = Vector2()
var WeaponNumber = 1 
var WeaponSelect = "M2"
var NewWeapon = true
var ChainSawEnable = false
var HitPoints = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	AnimPlayer = $AnimationPlayer
	Head = $Head
	TopHand = $TopHand
	BottomHand = $BottomHand


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	
	
	MousePosition = get_global_mouse_position()
	$TopHand.look_at(MousePosition)
	if NewWeapon:
		#print("NEW")
		$M2.set("ShootEnable",false)
		$M2.set("visible",false)
		$BabyTechBoomerDoomer.set("ShootEnable",false)
		$BabyTechBoomerDoomer.set("visible",false)
		$BigChainSaw.set("visible",false)
		$BigChainSaw/AnimatedSprite/CPUParticles2D.set("amount",1)
		match WeaponNumber:#Use WeaponNumber here?
			0:#"Chain Saw":
				HoldingPointOne = $BigChainSaw/AnimatedSprite/HoldingPoint 
				HoldingPointTwo = $BigChainSaw/AnimatedSprite/HoldingPoint2
				$BigChainSaw.set("visible",true)
				$BigChainSaw/AnimatedSprite/CPUParticles2D.set("amount",75)
			
			1:#"M2":
				HoldingPointOne = $M2/Sprite/HoldingPoint 
				HoldingPointTwo = $M2/Sprite/HoldingPoint2
				$M2.set("ShootEnable",true)
				$M2.set("visible",true)

			2:#"Boomer Doomer":
				HoldingPointOne = $BabyTechBoomerDoomer/Sprite/HoldingPoint 
				HoldingPointTwo = $BabyTechBoomerDoomer/Sprite/HoldingPoint2
				$BabyTechBoomerDoomer.set("ShootEnable",true)
				$BabyTechBoomerDoomer.set("visible",true)
			

			_:
				print("ERROR!")

		NewWeapon = false

	
	
	HoldingPointOneLocation = HoldingPointOne.global_transform.origin
	HoldingPointTwoLocation = HoldingPointTwo.global_transform.origin

	BottomHand.look_at(HoldingPointTwoLocation)
	TopHand.look_at(HoldingPointOneLocation)

	if WeaponNumber == 0:
		$BigChainSaw.look_at(MousePosition)


	Head.look_at(MousePosition)
	if position.x > MousePosition.x:
		Head.set("flip_v", true)
		$BigChainSaw.set("scale",Vector2(1,-1))
		#$BigChainSaw.set("position",Vector2(-24,-6))
	else:
		Head.set("flip_v", false)
		$BigChainSaw.set("scale",Vector2(1,1))
		#$BigChainSaw.set("position",Vector2(24,-6))
		
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
		
	if Input.is_action_pressed("Click") && WeaponNumber == 0:
		$BigChainSaw/AnimatedSprite.set("playing",true)
		$BigChainSaw/AnimatedSprite/CPUParticles2D.set("emitting",true)
		$BigChainSaw/Area2D.set("monitoring", true)
		ChainSawEnable = true
	else:
		$BigChainSaw/AnimatedSprite.set("playing",false)
		$BigChainSaw/AnimatedSprite/CPUParticles2D.set("emitting",false)
		$BigChainSaw/Area2D.set("monitoring", false)
		ChainSawEnable = false




func _physics_process(delta):

	dir = 0
	if Input.is_action_pressed('ui_right'):
		dir += 1
	if Input.is_action_pressed('ui_left'):
		dir -= 1

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)

		if position.x < MousePosition.x:
			AnimPlayer.set_current_animation("WalkRight")
		else:
			AnimPlayer.set_current_animation("WalkLeft")
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		if position.x < MousePosition.x:
			AnimPlayer.set_current_animation("StationaryRight")
		else:
			AnimPlayer.set_current_animation("StationaryLeft")

	if is_on_floor() and Input.is_action_pressed('ui_up'):
		velocity.y = -800

	velocity.y += 1000 * delta
	velocity = move_and_slide(velocity, Vector2(0,-1))


func _on_ChainSaw_body_entered(body):
	$BigChainSaw/Area2D.set_deferred("monitoring", false)
	if body.is_in_group("BadGuys"):
		body.Health -= 25

func _on_Timer_timeout():
	if ChainSawEnable:
		$BigChainSaw/Area2D.set("monitoring", true)


func _on_Area2D_area_entered(area):
	if area.is_in_group("BadGuyBullets"):
		HitPoints -= area.angular_damp
