class_name Entity
extends Node2D

@export var materialPath: String
@export var sprites: Array[Sprite2D]

var position3d: Vector3
var myMaterial : ShaderMaterial = null

func _ready():
	position3d = Vector3(global_position.x, 0, global_position.y)
	myMaterial = load(materialPath).duplicate()
	for sprite in sprites:
		sprite.material = myMaterial

func set_highlight(highlighted):
	var line_thickness = 4.9 if highlighted else 0
	myMaterial.set_shader_parameter("line_thickness", line_thickness)

func canInteractShort():
	pass

func canInteractLong():
	pass
	
func interactShort(entity):
	pass

func interactLong(entity):
	pass
