extends Node

var moveVector

func _ready():
	pass


func _process(delta):
	moveVector = Vector2(0,0)
	if Input.is_action_pressed("right"):
		moveVector.x += 1
	if Input.is_action_pressed("left"):
		moveVector.x -= 1
	if Input.is_action_pressed("up"):
		moveVector.y += 1
	if Input.is_action_pressed("down"):
		moveVector.y -= 1
	moveVector = moveVector.normalized()
	pass
	
	
func _physics_process(delta):
	pass
