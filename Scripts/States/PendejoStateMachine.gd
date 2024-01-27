class_name Pendejo_State_Machine
extends Entity

enum State{
	IDLE,
	MOVE,
	CLIMB,
	DESCEND
}

var current_state : State = State.IDLE

@export var speed: float = 5
@export var target: Entity

var animation_tree : AnimationTree

var moveVector = Vector2(0, 0)
var targetHeight : Vector3

func _ready():
	position3d = Vector3(position.x, 0, position.y)
	pass

func _process(delta):
	if current_state == State.IDLE:
			process_idle(delta)
	if current_state == State.MOVE:
			process_moving(delta)
	if current_state == State.CLIMB:
			process_climb(delta)
	if current_state == State.DESCEND:
			process_descend(delta)

func changeState(new_state: State) -> void:
	animation_tree = $AnimationTree_pibe
	match new_state:
		State.IDLE:
			animation_tree.set("parameters/climb/blend_amount", 0.0)
			animation_tree.set("parameters/Walk/blend_amount", 0.0)
			print("IDLE")
		State.MOVE:
			animation_tree.set("parameters/climb/blend_amount", 0.0)
			animation_tree.set("parameters/Walk/blend_amount", 1.0)
			print("MOVE")
	
		State.CLIMB:
			animation_tree.set("parameters/climb/blend_amount", 1.0)
			animation_tree.set("parameters/Walk/blend_amount", 1.0)
			print("CLIMB")
			
		State.DESCEND:
			animation_tree.set("parameters/climb/blend_amount", 1.0)
			animation_tree.set("parameters/Walk/blend_amount", 0.0)
			print("DESCEND")
			
	current_state = new_state

func process_idle(delta):
		#IDLE LOGIC
		if target != null:
			changeState(State.MOVE)

func process_moving(delta):
	#MOVING LOGIC
	if target == null:
		changeState(State.IDLE)
	if target != null:
		MovementHandler(delta)
"""		
	elif target.position == global_position:
		currentState = State.CLIMB
"""
func process_climb(delta):
	if global_position.y >= targetHeight.y && current_state == State.CLIMB:
		changeState(State.DESCEND)
	#CLIMBING LOGIC

func process_descend(delta):
	if position3d.y > target.position.y:
		changeState(State.MOVE)
	#DESCEND LOGIC

func MovementHandler(delta):
	position3d = position3d.move_toward(target.position3d, speed * delta)
	if global_position.distance_to(target.position) < 1:
		changeState(State.IDLE)
		print("location archived")
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
	global_position = Vector2(position3d.x, position3d.z - position3d.y)
	pass
