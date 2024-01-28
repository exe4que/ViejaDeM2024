extends Node

var entities = []
var entitiesToRemove = []
var mainCharacter: Vieja
var selectedEntity: Entity = null

func add_main_character(entity: Entity):
	mainCharacter = entity

func add_entity(entity):
	entities.append(entity)
	print("added: " + entity.name)

func remove_entity(entity):
	entitiesToRemove.append(entity)

func get_closest_entity_in_direction(direction: Vector2):
	var closestDistance = 1000000
	var closestEntity = null
	var pA = Vector2(mainCharacter.position3d.x, mainCharacter.position3d.z)
	for entity in entities:
		var pB = pA + direction * 10000
		var point = Vector2(entity.position3d.x, entity.position3d.z)
		var closestPoint = Geometry2D.get_closest_point_to_segment(point, pA, pB)
		var distance = point.distance_to(closestPoint)

		if closestEntity == null || distance < closestDistance:
			closestEntity = entity
			closestDistance = distance
	for entity in entitiesToRemove:
		entities.erase(entity)
		print("removed: " + entity.name)
	
	entitiesToRemove.clear()
	
	return closestEntity

func _process(delta):
	if mainCharacter != null:
		_process_mouse_position()

func _process_mouse_position():
	var mousePosition = get_viewport().get_mouse_position()
	var direction = mousePosition - Vector2(mainCharacter.position3d.x, mainCharacter.position3d.z)
	#print("direction: " + str(direction))
	var closestEntity: Entity = get_closest_entity_in_direction(direction.normalized())
	if closestEntity == null:
		selectedEntity = null
	if closestEntity != null && selectedEntity != closestEntity && closestEntity.can_be_highlighted():
		select_entity(closestEntity)

func select_entity(entity: Entity):
	if selectedEntity != null:
		selectedEntity.set_highlight(false)
	selectedEntity = entity
	selectedEntity.set_highlight(true)
	print("selected: " + entity.name)

func interact_short_distance():
	if mainCharacter.can_interact_short():
		if selectedEntity != null:
			var distance = mainCharacter.position3d.distance_to(selectedEntity.position3d)
			if distance < mainCharacter.shortInteractionDistance:
				if selectedEntity.can_interact_short():
					selectedEntity.interact_short(mainCharacter)
					mainCharacter.interact_short(selectedEntity)
				else:
					mainCharacter.interact_short(null)
			else:
				mainCharacter.interact_short(null)

func interact_long_distance():
	if mainCharacter.can_interact_long():
		if selectedEntity.can_interact_long():
			selectedEntity.interact_long(mainCharacter)
			mainCharacter.interact_long(selectedEntity)
			
