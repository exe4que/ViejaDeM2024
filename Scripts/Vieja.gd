class_name Vieja
extends Node2D

@export var speed: float = 5

var moveVector = Vector2(0, 0)
var position3d = Vector3(0, 0, 0)

func _ready():
	position3d = Vector3(position.x, 0, position.y)
	pass


func _process(delta):
	_handle_inputs()
	pass

func _physics_process(delta):
	position3d += Vector3(moveVector.x, 0, moveVector.y) * delta * speed
	var vLimits = GlobalManager.verticalLimits
	var hLimits = GlobalManager.horizontallLimits
	position3d.z = clampf(position3d.z, vLimits.x, vLimits.y)
	position3d.x = clampf(position3d.x, hLimits.x, hLimits.y)
	position = Vector2(position3d.x, position3d.y + position3d.z)
	pass
	
func _handle_inputs():
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
