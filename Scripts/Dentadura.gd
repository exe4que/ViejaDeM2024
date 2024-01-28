class_name Dentadura
extends Entity

@export var speed: float
var target: Entity
var initialized = false
var state: DentaduraState;

func _process(delta):
	if !initialized:
		return
	if state == DentaduraState.FLYING:
		var targetPos = target.position3d + Vector3(0, 100, 0)
		position3d = position3d.move_toward(targetPos, speed * delta)
		if(position3d.distance_to(targetPos) < 1):
			target.die()
			state = DentaduraState.FALLING_DOWN
			$bite.play()
	if state == DentaduraState.FALLING_DOWN:
		position3d = position3d.move_toward(Vector3(position3d.x, 0, position3d.z), speed * delta)
		if absf(position3d.y) < 1:
			EntitiesManager.add_entity(self)
			state = DentaduraState.IDLE
	if state == DentaduraState.IDLE:
		pass
	global_position = Vector2(position3d.x, position3d.z - position3d.y)

func fly_to(entity: Entity):
	global_position = Vector2(position3d.x, position3d.z - position3d.y)
	target = entity
	state = DentaduraState.FLYING
	initialized = true

func can_be_highlighted():
	return state == DentaduraState.IDLE

func interact_short(entity):
	entity.restore_dentadura()
	EntitiesManager.remove_entity(self)
	await get_tree().create_timer(0.2).timeout
	queue_free()

enum DentaduraState{
	FLYING,
	FALLING_DOWN,
	IDLE
}
