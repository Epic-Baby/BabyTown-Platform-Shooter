extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float, 0, 1.0) var friction = 0.15
export (float, 0, 1.0) var acceleration = 0.5
var velocity = Vector2()
var speed = 200
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
var HoseConnect = Vector2()
var HoseBase = Vector2()
var HitPoints = 100
var WelderEnable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	AnimPlayer = $AnimationPlayer
	Head = $Head
	TopHand = $TopHand
	BottomHand = $BottomHand



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	print(HitPoints)
	
	MousePosition = get_global_mouse_position()
	$TopHand.look_at(MousePosition)
	if NewWeapon:
		#print(WeaponNumber)
		$TopHand/RailGun.set("ShootEnable",false)
		$TopHand/RailGun.set("visible",false)
		$TopHand/Medikit.set("Enable",false)
		$TopHand/Medikit.set("visible",false)
		$TopHand/WeldingTorch.set("visible",false)
		$Body/Tank/Hose.set("visible",false)
		$TopHand/WeldingTorch/Torch/CPUParticles2D.set("amount",1)
		match WeaponNumber:#Use WeaponNumber here?
			0: 
				HoldingPointOne = $TopHand/WeldingTorch/Torch/HoldingPoint 
				HoldingPointTwo = $TopHand/WeldingTorch/Torch/HoldingPoint2
				$TopHand/WeldingTorch.set("visible",true)
				$Body/Tank/Hose.set("visible",true)
				$TopHand/WeldingTorch/Torch/CPUParticles2D.set("amount",100)

			1:
				HoldingPointOne = $TopHand/RailGun/Sprite/HoldingPoint 
				HoldingPointTwo = $TopHand/RailGun/Sprite/HoldingPoint2
				$TopHand/RailGun.set("ShootEnable",true)
				$TopHand/RailGun.set("visible",true)

			2:

				HoldingPointOne = $TopHand/Medikit/HoldingPoint 
				HoldingPointTwo = $TopHand/Medikit/HoldingPoint 
				$TopHand/Medikit.set("Enable",true)
				$TopHand/Medikit.set("visible",true)

			_:
				print("ERROR!")
				
		NewWeapon = false

	HoldingPointTwoLocation = HoldingPointTwo.global_transform.origin
	BottomHand.look_at(HoldingPointTwoLocation)
		
	Head.look_at(MousePosition)
	if position.x > MousePosition.x:
		Head.set("flip_v", true)
		$Body.set("flip_h",true)
		$Body/Tank.set("position",Vector2(11,-9))
		$TopHand/WeldingTorch.set("scale",Vector2(1,-1))
	else:
		Head.set("flip_v", false)
		$Body.set("flip_h",false)
		$Body/Tank.set("position",Vector2(-11,-9))
		$TopHand/WeldingTorch.set("scale",Vector2(1,1))

	



func _input(_event):
	if Input.is_action_just_pressed("ui_home"):
		HitPoints = 1
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
		$TopHand/WeldingTorch/Torch/CPUParticles2D.set("emitting", true)
		WelderEnable = true
	else:	
		$TopHand/WeldingTorch/Torch/CPUParticles2D.set("emitting", false)
		WelderEnable = false

	HoseConnect = $TopHand/WeldingTorch/Torch/HoseAttach.global_transform[2]
	HoseBase = $Body/Tank/Position2D.global_transform[2]
	$Body/Tank/Hose.add_point(HoseConnect-HoseBase+Vector2(0,-11))
	$Body/Tank/Hose.remove_point(1)


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
		velocity.y = -650
	
	velocity.y += 1000 * delta
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
	


#Speed = 200, Jump = 650



func _on_Welder_body_entered(body):
			$TopHand/WeldingTorch/Torch/Area2D.set_deferred("monitoring", false)
			if body.is_in_group("BadGuys"):
				body.Health -= 15


func _on_Timer_timeout():
	if WelderEnable:
		$TopHand/WeldingTorch/Torch/Area2D.set("monitoring", true)





func _on_Area2D_area_entered(area):
	if area.is_in_group("BadGuyBullets"):
		HitPoints -= area.angular_damp

