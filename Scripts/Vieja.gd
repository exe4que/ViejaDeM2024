class_name Vieja
extends CharacterBody2D

@export var speed: float = 5
@export var debug: bool = false

var moveVector = Vector2(0, 0)

func _ready():
	pass


func _process(delta):
	_handle_inputs()
	queue_redraw()
	pass

func _physics_process(delta):
	move_and_collide(moveVector * speed)
	#transform.y = clampf()
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

func _draw():
	if debug:
		draw_line(
			Vector2(-1000, GlobalManager.verticalLimits.x), 
			Vector2(1000, GlobalManager.verticalLimits.x), 
			Color.SPRING_GREEN)
		draw_line(
			Vector2(-1000, GlobalManager.verticalLimits.y), 
			Vector2(1000, GlobalManager.verticalLimits.y), 
			Color.SPRING_GREEN)
