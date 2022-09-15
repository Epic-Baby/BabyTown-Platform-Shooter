extends KinematicBody2D

const BadGuyArm = preload("res://BadGuys/BadGuyArm.tscn")
const BadGuyLeg = preload("res://BadGuys/BadGuyLeg.tscn")
const BadGuyBody = preload("res://BadGuys/BadGuyBody.tscn")
const BadGuyHead = preload("res://BadGuys/BadGuyHead.tscn")


# Declare member variables here. Examples:
signal BadGuyDead(HType,LType,AType,HPos,LPos,APos,BPos)
signal BadGuyShoot(Transformation, Damage)
# var a = 2
# var b = "text"
var Random = RandomNumberGenerator.new()
var HeadType = 0
var LegType = 0
var ArmType = 0
var Health = 100
export (float, 0, 1.0) var friction = 0.15
export (float, 0, 1.0) var acceleration = 0.5
var velocity = Vector2()
var speed = 150
var dir = 1
var NewDir = true
var PreviousDirection = 1
var TargetLocation = Vector2(0,0)
var Flipped = false
var TipOfWeapon
var InitialRotation = 0
var State = 0 #0 = Walk, 1 = Attack


# Called when the node enters the scene tree for the first time.
func _ready():
	TipOfWeapon = $Arms/RightArm/RightHand/BadGuyWeapon/Sprite/Position2D
	Random.randomize()
	HeadType = Random.randi_range(2,9)
	LegType = Random.randi_range(1,5)
	ArmType = Random.randi_range(1,5)
	$Arms/RightArm/RightHand/BadGuyWeapon.set("WeaponType", Random.randi_range(0,3))
	$Arms/RightArm/RightHand/BadGuyWeapon.set("Init", true)
	$Legs/RightLeg/RightFoot.set("frame_coords", Vector2(2,LegType))
	$Legs/LeftLeg/LeftFoot.set("frame_coords", Vector2(2,LegType))
	$Arms/RightArm/RightHand.set("frame_coords", Vector2(3,ArmType))
	$Arms/LeftArm/LeftHand.set("frame_coords", Vector2(3,ArmType))
	if HeadType < 5:
		$Head.set("frame_coords", Vector2(0,HeadType))
	else:
		$Head.set("frame_coords", Vector2(1,HeadType-5))



	#dir = Random.randf_range(-5,5)
#	$LegAnimationPlayer.set("playback_speed", abs(dir))
#	if dir < 0:
#		set("scale",Vector2(-1,1))
#		$HeadPosition2D.set("scale", Vector2(-1,1))
#		$LegPosition2D.set("scale", Vector2(-1,1))
#		$ArmPosition2D.set("scale", Vector2(-1,1))
#		$BodyPosition2D.set("scale", Vector2(-1,1))
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if (TargetLocation-position).length() < 400:
		#if Random.randi_range(0,10) == 4:
		State = 1
	else:
		State = 0
	
	
	
	if State == 1:
		$Arms/ArmAnimationPlayer.play("Aim")
		if TargetLocation.x > get_global_position().x:
			$Arms.set("scale", Vector2(1,1))

		else:
			$Arms.set("scale", Vector2(-1,1))
	
	

		$Arms.look_at(TargetLocation)
		$BulletOrigin.look_at(TargetLocation)
		$Arms.set("rotation_degrees",$Arms.get("rotation_degrees")+270)
		$BulletOrigin.set("position", TipOfWeapon.global_position-global_position)
		
		
		#Random.randi_range(0,4) == 4 && 
		
		if $Arms/RightArm/RightHand/BadGuyWeapon.get("Loaded"):
			#InitialRotation = TipOfWeapon.get("rotation_degrees")
			$Arms/RightArm/RightHand/BadGuyWeapon.set("Fire", true)
			if $Arms/RightArm/RightHand/BadGuyWeapon.get("WeaponType") != 3:
				$BulletOrigin.set("rotation_degrees", $BulletOrigin.get("rotation_degrees")+Random.randi_range(-$Arms/RightArm/RightHand/BadGuyWeapon.get("Inaccuracy"),$Arms/RightArm/RightHand/BadGuyWeapon.get("Inaccuracy")))
				emit_signal("BadGuyShoot", $BulletOrigin.global_transform, $Arms/RightArm/RightHand/BadGuyWeapon.get("Damage"))
			else:
				for x in 6:
					$BulletOrigin.set("rotation_degrees", $BulletOrigin.get("rotation_degrees")+Random.randi_range(-$Arms/RightArm/RightHand/BadGuyWeapon.get("Inaccuracy"),$Arms/RightArm/RightHand/BadGuyWeapon.get("Inaccuracy")))
					emit_signal("BadGuyShoot", $BulletOrigin.global_transform, $Arms/RightArm/RightHand/BadGuyWeapon.get("Damage"))
					$BulletOrigin.look_at(TargetLocation)
		#TipOfWeapon.set("rotation_degrees", InitialRotation)
	else:
		$Arms/ArmAnimationPlayer.play("Walk")
		$Arms.set("rotation_degrees", 0)
		$Arms.set("scale", Vector2(dir/abs(dir),1))
	
	if NewDir:
		$LegAnimationPlayer.set("playback_speed", abs(dir))
		$Arms/ArmAnimationPlayer.set("playback_speed", abs(dir))
		if dir * PreviousDirection < 0:
			$Legs.scale.x *= -1
			$Arms.scale.x *= -1
			
			#$HeadPosition2D.set("scale", Vector2(dir/abs(dir),1))
			#$LegPosition2D.set("scale", Vector2(dir/abs(dir),1))
			#$ArmPosition2D.set("scale", Vector2(dir/abs(dir),1))
			#$BodyPosition2D.set("scale", Vector2(dir/abs(dir),1))
			#TipOfWeapon.set("scale", Vector2(dir/abs(dir),1))
			#TipOfWeapon.set("rotation_degrees",TipOfWeapon.get("rotation_degrees")+180)
			#$BulletOrigin.set("scale", Vector2(dir/abs(dir),1))
			#$Arms.set("scale", Vector2(dir/abs(dir),1))
			Flipped = !Flipped
#		else:
#			scale.x = 1
#
#			$HeadPosition2D.set("scale", Vector2(1,1))
#			$LegPosition2D.set("scale", Vector2(1,1))
#			$ArmPosition2D.set("scale", Vector2(1,1))
#			$BodyPosition2D.set("scale", Vector2(1,1))
		NewDir = false
	
	
	if Input.is_action_just_pressed("ui_accept"):
		Health -= 10
		
	if Random.randi_range(0,400) == 4 or is_on_wall():
		PreviousDirection = dir
		dir = Random.randf_range(-5,5)
		NewDir = true



	if Health < 1:


		emit_signal("BadGuyDead",HeadType,LegType,ArmType,$HeadPosition2D.global_transform,$LegPosition2D.global_transform,$ArmPosition2D.global_transform,$BodyPosition2D.global_transform)

		queue_free()
		

func _physics_process(delta):

	#dir = 0
	#if Input.is_action_pressed('ui_right'):
	#	dir += 1
	#if Input.is_action_pressed('ui_left'):
	#	dir -= 1

		
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		$LegAnimationPlayer.set_current_animation("Walk")
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		$LegAnimationPlayer.set_current_animation("Upright")
	
	if is_on_floor() and Random.randi_range(0,250) == 4:
		velocity.y = -1000
	

	
	velocity.y += 1000 * delta
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
func _on_Area2D_area_entered(_area):
	if is_on_floor() and Random.randi_range(0,1) == 1:
		velocity.y = -1000


func _on_BabyPositionGet(Location):
	TargetLocation = Location
