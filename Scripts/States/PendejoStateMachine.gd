class_name Pendejo_State_Machine
extends Node2D

enum{
	IDLE,
	WALK,
	CLIMB,
	DESCEND
}

@export var speed: float = 5

var moveVector = Vector2(0, 0)
var position3d = Vector3(0, 0, 0)

var target : Node2D = null
var state = IDLE

func _ready():
	position3d = Vector3(position.x, 0, position.y)
	pass

func _process(delta):
	if target:
		state = WALK
	else:
		state = IDLE
	
	match state:
		IDLE:
			#PLAY IDLE ANIMATION
			return
		WALK:
			#PLAY WALK ANIMATION
			var direction = (target.global_position - global_position). normalized()
			
			global_position += direction * speed * delta
		#CLIMB:
			#PLAY CLIMB ANIMATION
		#DESCEND:
			#PLAY DESCEND ANIMATION

func SetTarget(new_target: Node2D) -> void:
	target = new_target
	
func _physics_process(delta):
	position3d += Vector3(moveVector.x, 0, moveVector.y) * delta * speed
	var vLimits = GlobalManager.verticalLimits
	var hLimits = GlobalManager.horizontallLimits
	position3d.z = clampf(position3d.z, vLimits.x, vLimits.y)
	position3d.x = clampf(position3d.x, hLimits.x, hLimits.y)
	position = Vector2(position3d.x, position3d.y + position3d.z)
	pass
