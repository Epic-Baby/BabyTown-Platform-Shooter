extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Random = RandomNumberGenerator.new()
var PartNumber = 1
var PartType
var Init = false
var Health = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !Init:
		PartType = $RigidBody2D/Sprite.get("frame_coords")
		if PartType.x == 2 or PartType.x == 3: #Leg or Arm
			$RigidBody2D/Sprite.set("frame_coords", Vector2(PartType.x,PartNumber))
		elif PartType != Vector2(0,0): #Head
			if PartNumber != 9:
				Random.randomize()
				if Random.randi_range(0,10) > 8:
					PartNumber = 5
				elif Random.randi_range(0,10) < 1:
					PartNumber = 11
				else:
					if PartNumber > 4:
						PartNumber = PartNumber + 1
						
			else:
				PartNumber = 10


			if PartNumber < 6:
				$RigidBody2D/Sprite.set("frame_coords", Vector2(0,PartNumber))
			else:
				$RigidBody2D/Sprite.set("frame_coords", Vector2(1,PartNumber-6))

		Init = true

	if Health < 1:
		queue_free()




func _on_Timer_timeout():
	queue_free()
