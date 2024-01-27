class_name Vieja
extends Node2D

@export var speed: float = 5
@export var myMaterial: ShaderMaterial


var moveVector = Vector2(0, 0)
var position3d = Vector3(0, 0, 0)


func _ready():
	position3d = Vector3(position.x, 0, position.y)
	pass


func _process(delta):
	_handle_inputs()
	_handle_mirror_sprite()
	pass
	
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


var highlighted = false;
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
		
	if Input.is_action_just_pressed("main_action"):
		highlighted = !highlighted
		set_highlight(highlighted)
		
func set_highlight(highlighted):
	var color = myMaterial.get_shader_parameter("line_color")
	color.a = 1 if highlighted else 0
	myMaterial.set_shader_parameter("line_color", color)
