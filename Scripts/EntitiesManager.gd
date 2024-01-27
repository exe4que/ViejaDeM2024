extends Node

var entities = []
var mainCharacter: Entity
var selectedEntity = null

func add_main_character(entity: Entity):
	mainCharacter = entity

func add_entity(entity):
	entities.append(entity)

func remove_entity(entity):
	entities.append(entity)

func get_closest_entity_in_direction(direction: Vector2):
	var closestDistance = 1000000
	var closestEntity = null
	var pA = Vector2(mainCharacter.position3d.x, mainCharacter.position3d.z)
	for entity in entities:
		var pB = pA + direction * 10000
		var point = Vector2(entity.position3d.x, entity.position3d.z)
		var closestPoint = Geometry2D.get_closest_point_to_segment(point, pA, pB)
		var distance = pA.direction_to(closestPoint)

		if closestEntity == null || distance < closestDistance:
			closestEntity = entity
			closestDistance = distance
	
	return closestEntity

func select_entity(entity: Entity):
	if selectedEntity != null:
		selectedEntity.set_highlight(false)
	selectedEntity = entity
	selectedEntity.set_highlight(true)
