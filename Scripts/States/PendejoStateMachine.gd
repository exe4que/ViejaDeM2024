class_name Pendejo_State_Machine
extends Node2D

enum State
{
	IDLE,
	MOVE,
	CLIMB,
	DESCEND
}

var currentState : State = State.IDLE

@export var speed: float = 5
@export var target: Node2D

var animation_tree : AnimationTree

var moveVector = Vector2(0, 0)
var position3d = Vector3(0, 0, 0)

var targetHeight : Vector3

func _ready():
	animation_tree = $AnimationTree_pibe
	position3d = Vector3(position.x, 0, position.y)
	pass

func _process(delta):
	match currentState:
		State.IDLE:
			process_idle(delta)
			print("IDLE")
		State.MOVE:
			process_moving(delta)	
			print("MOVE")
	"""
		State.CLIMB:
			process_climb(delta)
			print("CLIMB")
		State.DESCEND:
			process_descend(delta)
			print("DESCEND")
	"""

func process_idle(delta):
		#IDLE LOGIC, AIMATION, ETC		
		animation_tree.set("parameters/climb/blend_amount", 0.0)
		animation_tree.set("parameters/Walk/blend_amount", 0.0)
		if target != null:
			currentState = State.MOVE

func process_moving(delta):
	#MOVING LOGIC, AIMATION, ETC	
	if target == null:
		currentState = State.IDLE
	if target != null:
		animation_tree.set("parameters/climb/blend_amount", 0.0)
		animation_tree.set("parameters/Walk/blend_amount", 1.0)
		MoveToTarget(delta)
"""		
	elif target.position == global_position:
		currentState = State.CLIMB
"""
func process_climb(delta):
	if global_position.y >= targetHeight.y && currentState == State.CLIMB:
		currentState = State.DESCEND
	#CLIMBING LOGIC, AIMATION, ETC

func process_descend(delta):
	if position3d.y > target.position.y:
		currentState = State.MOVE
	#DESCEND LOGIC

func MoveToTarget(delta):

	var direction = (target.global_position - global_position). normalized()
	global_position = global_position.move_toward(target.global_position, speed * delta)
	if global_position.distance_to(target.position) < 1:
		print("location archived")
		currentState = State.IDLE
		target = null
		"""
		await get_tree().create_timer(2.0).timeout
		currentState = State.MOVE
		return
"""
func _physics_process(delta):
	position3d += Vector3(moveVector.x, 0, moveVector.y) * delta * speed
	var vLimits = GlobalManager.verticalLimits
	var hLimits = GlobalManager.horizontallLimits
	position3d.z = clampf(position3d.z, vLimits.x, vLimits.y)
	position3d.x = clampf(position3d.x, hLimits.x, hLimits.y)
	position = Vector2(position3d.x, position3d.y + position3d.z)
	pass
