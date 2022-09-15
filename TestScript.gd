extends Node2D

const BadGuy = preload("res://BadGuys/BadGuy.tscn")

const BadGuyArm = preload("res://BadGuys/BadGuyArm.tscn")
const BadGuyLeg = preload("res://BadGuys/BadGuyLeg.tscn")
const BadGuyBody = preload("res://BadGuys/BadGuyBody.tscn")
const BadGuyHead = preload("res://BadGuys/BadGuyHead.tscn")

const Bullet = preload("res://Weapons/Bullets/BadGuyBullet.tscn")

signal BabyGlobalPosition(Location)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Random = RandomNumberGenerator.new()

var HeadType = 0
var LegType = 0
var ArmType = 0
var Kills = 0
const BabyNumber = 2#Random.randi_range(0, 4)
var BabyPosition = Vector2(0,0)
var CurrentBaby
const GODMODE = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if BabyNumber != 0:
		$SmallBaby.queue_free()
	if BabyNumber != 1:
		$MeanBaby.queue_free()
	if BabyNumber != 2:
		$DeathBringerBaby.queue_free()	
	if BabyNumber != 3:
		$BuffBaby.queue_free()
	if BabyNumber != 4:
		$MadScientistBaby.queue_free()
		
	if BabyNumber == 0:
		CurrentBaby = $SmallBaby
	if BabyNumber == 1:
		CurrentBaby = $MeanBaby
	if BabyNumber == 2:
		CurrentBaby = $DeathBringerBaby
	if BabyNumber == 3:
		CurrentBaby = $BuffBaby
	if BabyNumber == 4:
		CurrentBaby = $MadScientistBaby
	
	

	for x in 10:
		var NewBadGuy = BadGuy.instance()
		add_child(NewBadGuy)
		NewBadGuy.position = Vector2(Random.randf_range(-200, 1000),600)
		NewBadGuy.connect("BadGuyDead", self, "_on_BadGuyDead")
		NewBadGuy.connect("BadGuyShoot", self, "_on_BadGuyShoot")
		self.connect("BabyGlobalPosition", NewBadGuy, "_on_BabyPositionGet")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	BabyPosition = CurrentBaby.position
	if CurrentBaby.get("HitPoints") < 1:
		if GODMODE:
			
			CurrentBaby.set("HitPoints", 100)
		else:
			get_tree().quit()
		
	BabyPosition = Vector2(round(BabyPosition.x),round(BabyPosition.y))
	emit_signal("BabyGlobalPosition",BabyPosition)
	

func _on_BadGuyDead(HType, LType, AType, HPos, LPos, APos, BPos):
	var NewBadGuy = BadGuy.instance()
	add_child(NewBadGuy)
	#set_owner()
	NewBadGuy.position = Vector2(Random.randf_range(-200, 1000),600)
	NewBadGuy.connect("BadGuyDead", self, "_on_BadGuyDead")
	NewBadGuy.connect("BadGuyShoot", self, "_on_BadGuyShoot")
	self.connect("BabyGlobalPosition", NewBadGuy, "_on_BabyPositionGet")
	Kills += 1
	print(Kills)
	
	
	
	var Legs = [BadGuyLeg.instance(),BadGuyLeg.instance()]
	var Arms = [BadGuyArm.instance(),BadGuyArm.instance()]
	var Head = BadGuyHead.instance()
	var Body = BadGuyBody.instance()

	for ArmsDropped in 2:
		add_child(Arms[ArmsDropped])
		Arms[ArmsDropped].transform = APos
		Arms[ArmsDropped].PartNumber = AType

	for LegsDropped in 2:
		add_child(Legs[LegsDropped])
		Legs[LegsDropped].transform = LPos
		Legs[LegsDropped].PartNumber = LType

	add_child(Head)
	Head.transform = HPos
	Head.PartNumber = HType

	add_child(Body)
	Body.transform = BPos
	#https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html







func _on_BadGuyShoot(Transformation, Damage):
	var b = Bullet.instance()
	add_child(b)
	b.transform = Transformation
	b.damage = Damage
