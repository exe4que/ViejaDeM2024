class_name Pendejo_State_Machine
extends Entity

enum State{
	IDLE,
	MOVE,
	CLIMB,
	DESCEND,
	DEAD,
	EXIT
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
var died = false

func _ready():
	myMaterial = load(materialPath).duplicate()
	for sprite in sprites:
		sprite.material = myMaterial
		sprite.z_index = sprite.z_index - 102
		
func initialize(ballEntity: Entity):
	climbTarget = $ClimbTarget
	ballTarget = ballEntity
	position3d = Vector3(ballTarget.position3d.x, 0, -100)
	chasingBall = false
	gotTheBall = false
	escaping = false
	died = false
	targetHeight = 220
	chase_climb_target()
	
	
func chase_climb_target():
	climbTarget.position3d = Vector3(position3d.x, 0, GlobalManager.verticalLimits.x)
	set_target(climbTarget)
	chasingFence = true
	changeState(State.MOVE)

func set_target(entity: Entity):
	target = entity

func _process(delta):
	if !GlobalManager.running:
		return
	if !gotTheBall && current_state != State.DEAD && current_state != State.EXIT && ballTarget == null:
		changeState(State.DEAD)
	else: if current_state == State.IDLE:
		process_idle(delta)
	else: if current_state == State.MOVE:
		process_moving(delta)
	else: if current_state == State.CLIMB:
		process_climb(delta)
	else: if current_state == State.DESCEND:
		process_descend(delta)
	else: if current_state == State.DEAD:
		#fall and scape to the side
		position3d += Vector3(-speed * delta, -speed * delta, 0)
		if position3d.y < 0:
			position3d.y = 0
		if position3d.x < -100:
			changeState(State.EXIT)

func changeState(new_state: State) -> void:
	animation_tree = $AnimationTree_pibe
	match new_state:
		State.IDLE:
			animation_tree.set("parameters/climb/blend_amount", 0.0)
			animation_tree.set("parameters/Walk/blend_amount", 0.0)
			#print("IDLE")
		State.MOVE:
			animation_tree.set("parameters/climb/blend_amount", 0.0)
			animation_tree.set("parameters/Walk/blend_amount", 1.0)
			#print("MOVE")
		State.CLIMB:
			animation_tree.set("parameters/climb/blend_amount", 1.0)
			animation_tree.set("parameters/Walk/blend_amount", 1.0)
			#print("CLIMB")
		State.DESCEND:
			for sprite in sprites:
				sprite.material = myMaterial
				var delta = -80 if gotTheBall else 80
				sprite.z_index = sprite.z_index + delta
			if !gotTheBall:
				EntitiesManager.add_entity(self)
			animation_tree.set("parameters/climb/blend_amount", 1.0)
			animation_tree.set("parameters/Walk/blend_amount", 0.0)
			#print("DESCEND")
		State.DEAD:
			animation_tree.set("parameters/climb/blend_amount", 0.0)
			animation_tree.set("parameters/Walk/blend_amount", 1.0)
			died = true
			#print("DEAD")
		State.EXIT:
			#print("EXIT")
			EntitiesManager.remove_entity(self)
			current_state = new_state
			await get_tree().create_timer(2).timeout
			queue_free()
			if gotTheBall && !died:
				GlobalManager.lost()
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
		var distance = position3d.distance_to(target.position3d)
		if distance < 1:
			if chasingFence:
				changeState(State.CLIMB)
			else: if chasingBall:
					chasingBall = false
					gotTheBall = true
					ballTarget.die()
					chase_climb_target()
			else: if escaping:
				changeState(State.EXIT)


func process_climb(delta):
	position3d.y += climbSpeed * delta
	if position3d.y > targetHeight:
		changeState(State.DESCEND)
	#CLIMBING LOGIC, AIMATION, ETC

func process_descend(delta):
	position3d.y -= climbSpeed * delta
	if position3d.y < 0:
		if gotTheBall:
			#escape
			climbTarget.position3d = Vector3(position3d.x, 0, -100)
			chasingFence = false
			escaping = true
			set_target(climbTarget)
		else:
			chasingBall = true
			chasingFence = false
			set_target(ballTarget)
		changeState(State.MOVE)
	#DESCEND LOGIC

func _physics_process(delta):
	global_position = Vector2(position3d.x, position3d.z - position3d.y)
	pass

func can_interact_short():
	return !died

func can_interact_long():
	return !died

func can_be_highlighted():
	return !died

func interact_short(entity):
	changeState(State.DEAD)
	$Bonk.play()

func interact_long(entity):
	changeState(State.IDLE)

func die():
	changeState(State.DEAD)
