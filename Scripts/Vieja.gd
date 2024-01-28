class_name Vieja
extends Entity

@export var speed: float = 5
@export var shortInteractionDistance: float = 5
@export var idleWalkBlendDuration: float = 0.3

var moveVector: Vector2 = Vector2(0, 0)
var dentaduraRes = preload("res://Scenes/dentadura.tscn")
var hasDentadura = true
var animationTree: AnimationTree
var move_blend = 0
var inputEnabled = true

func _ready():
	animationTree = $AnimationTree_vieja
	position3d = Vector3(global_position.x, 0, global_position.y)
	hasDentadura = true
	inputEnabled = true
	EntitiesManager.add_main_character(self)
	GlobalManager.start()

func _process(delta):
	if inputEnabled:
		_handle_inputs()
	else:
		moveVector = Vector2(0,0)
	_handle_mirror_sprite()
	_handle_animations(delta)
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, shortInteractionDistance, Color(1,0,0,0.3))
	
func _handle_mirror_sprite():
	if moveVector.x > 0:
		scale.x = -1
	else: if moveVector.x < 0:
		scale.x = 1

func _handle_animations(delta):
	if moveVector.length() > 0:
		move_blend += (1.0 / idleWalkBlendDuration) * delta;
	else:
		move_blend -= (1.0 / idleWalkBlendDuration) * delta;
	move_blend = clamp(move_blend, 0, 1)
	animationTree.set("parameters/Walk/blend_amount", move_blend)
	

func _physics_process(delta):
	position3d += Vector3(moveVector.x, 0, moveVector.y) * delta * speed
	var vLimits = GlobalManager.verticalLimits
	var hLimits = GlobalManager.horizontallLimits
	position3d.z = clampf(position3d.z, vLimits.x, vLimits.y)
	position3d.x = clampf(position3d.x, hLimits.x, hLimits.y)
	global_position = Vector2(position3d.x, position3d.z - position3d.y)
	pass

func _handle_inputs():
	#movement
	moveVector = Vector2(0,0)
	if Input.is_action_pressed("right"):
		moveVector.x += 1
	if Input.is_action_pressed("left"):
		moveVector.x -= 1
	if Input.is_action_pressed("up"):
		moveVector.y -= 1
	if Input.is_action_pressed("down"):
		moveVector.y += 1
	moveVector = moveVector.normalized()
	
	#actions
	if(Input.is_action_just_pressed("main_action")):
		EntitiesManager.interact_short_distance()
	
	if(Input.is_action_just_pressed("secondary_action")):
		EntitiesManager.interact_long_distance()

func can_interact_short():
	return true
	
func can_interact_long():
	return true

func interact_short(entity):
	if entity is Dentadura:
		return
	if entity is Ball:
		animationTree.set("parameters/attack_ball/request", 
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		stabBallSFX()
		inputEnabled = false
		await get_tree().create_timer(2).timeout
		inputEnabled = true
		animationTree.set("parameters/attack_ball/request", 
		AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		return
	animationTree.set("parameters/attack_boy/request", 
	AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await get_tree().create_timer(0.5).timeout
	animationTree.set("parameters/attack_boy/request", 
	AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func interact_long(entity):
	if hasDentadura:
		var newDentadura: Dentadura = dentaduraRes.instantiate()
		newDentadura.position3d = self.position3d + Vector3(0, 100, 0)
		newDentadura.fly_to(entity)
		get_tree().root.add_child(newDentadura)
		hasDentadura = false

func restore_dentadura():
	hasDentadura = true
	
func stabBallSFX():
	await get_tree().create_timer(0.2).timeout
	$"../Knife".play()
	await get_tree().create_timer(0.8).timeout
	$"../Stab".play()
