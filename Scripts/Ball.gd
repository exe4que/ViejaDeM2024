extends Entity

@export var fallSpeed: float = 500

var initialized = false

var initHeight
var targetPos: Vector3

func initialize(position: Vector3):
	targetPos = position
	print("pos: " + str(targetPos))
	initialized = true
	position3d = targetPos + Vector3(0, 1000, 0)
	print("p3d: " + str(position3d))
	global_position = Vector2(position3d.x, position3d.z - position3d.y)
	print("global: " + str(global_position))
	initHeight = global_position.y
	EntitiesManager.add_entity(self)
	_bounce()

func _process(delta):
	if initialized:
		position3d = Vector3(position3d.x, global_position.y + targetPos.z, position3d.z)

func _bounce():
	var tween = get_tree().create_tween()
	tween.tween_property(self, 
	"position:y", 
	initHeight + 1000, 3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

func interact_short(entity):
	EntitiesManager.remove_entity(self)
	await get_tree().create_timer(0.2).timeout
