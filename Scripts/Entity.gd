class_name Entity
extends Node2D

@export var myMaterial: ShaderMaterial
var position3d: Vector3

func set_highlight(highlighted):
	var color = myMaterial.get_shader_parameter("line_color")
	color.a = 1 if highlighted else 0
	myMaterial.set_shader_parameter("line_color", color)
