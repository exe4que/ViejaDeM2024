class_name Pendejo_State_Machine
extends Entity

enum State{
	IDLE,
	MOVE,
	CLIMB,
	DESCEND,
	DEAD
}

var current_state : State = State.IDLE

@export var speed: float = 100
@export var climbSpeed: float = 100
@export var target: Entity

var animation_tree : AnimationTree

var moveVector = Vector2(0, 0)
var targetHeight : float
var climbTarget: Entity
var ballTarget: Entity

var chasingFence = false
var initialized = false
var gotTheBall = false
var chasingBall = false
var escaping = false

func initialize(ballEntity: Entity):
	super._ready()
	climbTarget = $ClimbTarget
	ballTarget = ballEntity
	chasingBall = false
	gotTheBall = false
	escaping = false
	chase_climb_target()
	
	
func chase_climb_target():
	climbTarget.position3d = Vector3(position3d.x, 0, GlobalManager.verticalLimits.y)
	set_target(climbTarget)
	chasingFence = true
	changeState(State.MOVE)

func set_target(entity: Entity):
	target = entity

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
		State.DEAD:
			climbTarget.position3d = Vector3(-100, 0, position3d.z)
			set_target(climbTarget)
	current_state = new_state

func process_idle(delta):
	pass
	 

func process_moving(delta):
	#MOVING LOGIC, AIMATION, ETC	
	if target == null:
		if chasingBall:
			changeState(State.DEAD)
	if target != null:
		position3d = position3d.move_toward(target.position3d, speed * delta)
		position3d.y = 0
		if global_position.distance_to(target.position) < 1:
			if chasingFence:
				changeState(State.CLIMB)
			else: if chasingBall:
					chasingBall = false
					gotTheBall = true
					chase_climb_target()
			else: if escaping:
				changeState(State.IDLE)
			print("location archived")


func process_climb(delta):
	position3d.y += climbSpeed * delta
	if position3d.y > targetHeight && current_state == State.CLIMB:
		changeState(State.DESCEND)
	#CLIMBING LOGIC, AIMATION, ETC

func process_descend(delta):
	position3d.y -= climbSpeed * delta
	if position3d.y < GlobalManager.verticalLimits.y:
		if gotTheBall:
			#escape
			climbTarget.position3d = Vector3(position3d.x, 0, -1000)
			escaping = true
			set_target(climbTarget)
		else:
			chasingBall = true
			set_target(ballTarget)
		changeState(State.MOVE)
	#DESCEND LOGIC

func _physics_process(delta):
	position3d += Vector3(moveVector.x, 0, moveVector.y) * delta * speed
	var vLimits = GlobalManager.verticalLimits
	var hLimits = GlobalManager.horizontallLimits
	position3d.z = clampf(position3d.z, vLimits.x, vLimits.y)
	position3d.x = clampf(position3d.x, hLimits.x, hLimits.y)
	global_position = Vector2(position3d.x, position3d.y + position3d.z)
	pass
