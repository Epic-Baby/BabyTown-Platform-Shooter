extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var TimerOff = true
var CurrentHealth = 0
var InitialHealth = 100
var BigMode = false
var Init = false
var Enable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Init = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("Click") && TimerOff && Enable:
		$Timer.start()
		TimerOff = false
		
	if !Init:
		if BigMode:
			set("frame",6)
			set("position",Vector2(14,0)) #Change 4 to correct number
		else:
			set("frame",0)
			set("position",Vector2(7,0))
		
		InitialHealth = owner.get("HitPoints")
		Init = true

func _on_Timer_timeout():
	CurrentHealth = owner.get("HitPoints")
	if CurrentHealth < InitialHealth:
		owner.set("HitPoints", CurrentHealth + 1)
	TimerOff = true
