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
var MousePosition
var Head
var TopHand
var BottomHand
var HoldingPointOne
var HoldingPointTwo
var HoldingPointOneLocation = Vector2()
var HoldingPointTwoLocation = Vector2()
var WeaponNumber = 1 #0->Hand to hand 1->Primary 2->Secondary
var NewWeapon = true
var ThunderFistVariable = Vector2()
var HitPoints = 120

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
		#print(WeaponNumber)
		$TopHand/BiggerShot.set("ShootEnable",false)
		$TopHand/BiggerShot.set("visible",false)
		$TopHand/BabyTechMultiShot.set("ShootEnable",false)
		$TopHand/BabyTechMultiShot.set("visible",false)
		$TopHand/Area2D.set("monitoring",false)
		match WeaponNumber:#Use WeaponNumber here?
			0: #ThunderFist
				pass
			
			1:#"BiggerShot":
				HoldingPointOne = $TopHand/BiggerShot/Sprite/HoldingPoint 
				HoldingPointTwo = $TopHand/BiggerShot/Sprite/HoldingPoint2
				$TopHand/BiggerShot.set("ShootEnable",true)
				$TopHand/BiggerShot.set("visible",true)
				
			2:#"Multi":
				
				HoldingPointOne = $TopHand/BabyTechMultiShot/Sprite/HoldingPoint 
				HoldingPointTwo = $TopHand/BabyTechMultiShot/Sprite/HoldingPoint2
				$TopHand/BabyTechMultiShot.set("ShootEnable",true)
				$TopHand/BabyTechMultiShot.set("visible",true)

			_:
				print("ERROR!")
				
		NewWeapon = false

	if WeaponNumber == 0: #CHANGE THIS LATER != 0
		BottomHand.look_at(MousePosition)
	else:
		HoldingPointTwoLocation = HoldingPointTwo.global_transform.origin
		BottomHand.look_at(HoldingPointTwoLocation)
	
	
	Head.look_at(MousePosition)
	if position.x > MousePosition.x:
		Head.set("flip_v", true)
		$Body.set("flip_h",true)
		$TopHand/BiggerShot.set("position",Vector2(0,2))
	else:
		Head.set("flip_v", false)
		$Body.set("flip_h",false)
		$TopHand/BiggerShot.set("position",Vector2(0,-2))

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
		ThunderFistVariable.x = 7*cos(deg2rad($TopHand.get("rotation_degrees")))
		ThunderFistVariable.y = 7*sin(deg2rad($TopHand.get("rotation_degrees"))) - 14
		$TopHand.set("position", ThunderFistVariable)
		$TopHand/Area2D.set("monitoring",true)
		$ThunderFistTimer.start()

	if Input.is_action_just_released("Click"):
		$TopHand.set("position",Vector2(0,-14))
		$TopHand/Area2D.set("monitoring",false)



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
		velocity.y = -850
	
	velocity.y += 1000 * delta
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
	


#Speed = 250, Jump = 850


func _on_ThunderFistTimer_timeout():

	$TopHand.set("position",Vector2(0,-14))
	$TopHand/Area2D.set("monitoring",false)


func _on_ThunderFist_body_entered(body):
	if body.is_in_group("BadGuys"):
		body.Health -= 75


func _on_Area2D_area_entered(area):
	if area.is_in_group("BadGuyBullets"):
		HitPoints -= area.angular_damp
		print(HitPoints)
