class_name Vieja
extends Entity

@export var speed: float = 5
@export var shortInteractionDistance: float = 5

var moveVector = Vector2(0, 0)


func _ready():
	position3d = Vector3(global_position.x, 0, global_position.y)
	EntitiesManager.add_main_character(self)
	pass


func _process(delta):
	_handle_inputs()
	_handle_mirror_sprite()
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, shortInteractionDistance, Color(1,0,0,0.3))
	
func _handle_mirror_sprite():
	if moveVector.x > 0:
		scale.x = -1
	else: if moveVector.x < 0:
		scale.x = 1

func _physics_process(delta):
	position3d += Vector3(moveVector.x, 0, moveVector.y) * delta * speed
	var vLimits = GlobalManager.verticalLimits
	var hLimits = GlobalManager.horizontallLimits
	position3d.z = clampf(position3d.z, vLimits.x, vLimits.y)
	position3d.x = clampf(position3d.x, hLimits.x, hLimits.y)
	global_position = Vector2(position3d.x, position3d.y + position3d.z)
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
	print("bastonazo!")
	pass

func interact_long(entity):
	print("dentadura!")
	pass
	
