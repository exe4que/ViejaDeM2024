class_name Ball
extends Entity

@export var fallSpeed: float = 500

var initialized = false

var initHeight
var targetPos: Vector3

func initialize(position: Vector3):
	targetPos = position
	initialized = true
	position3d = targetPos + Vector3(0, 1000, 0)
	global_position = Vector2(position3d.x, position3d.z - position3d.y)
	initHeight = global_position.y
	EntitiesManager.add_entity(self)
	_bounce()

func _process(delta):
	if initialized:
		position3d = Vector3(position3d.x, global_position.y - position3d.z, position3d.z)
		pass

func _bounce():
	var tween = get_tree().create_tween()
	tween.tween_property(self, 
	"position:y", 
	initHeight + 1000, 3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

func interact_short(entity):
	EntitiesManager.remove_entity(self)
	await get_tree().create_timer(1).timeout
	queue_free()

func can_interact_long():
	return false
