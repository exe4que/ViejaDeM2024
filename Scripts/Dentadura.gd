extends Entity

@export var speed: float
var target: Entity
var initialized = false

func _physics_process(delta):
	position3d = position3d.move_toward(target.position3d, speed * delta)
	global_position = Vector2(position3d.x, position3d.y + position3d.z)
	if(position3d.distance_to(target.position3d) < 1):
		target.die()

func fly_to(entity: Entity):
	target = entity
	initialized = true
