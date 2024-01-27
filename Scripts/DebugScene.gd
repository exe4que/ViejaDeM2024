extends Node2D

@export var debug: bool = false

func _process(delta):
	queue_redraw()

func _draw():
	var vLimits = GlobalManager.verticalLimits
	var hLimits = GlobalManager.horizontallLimits
	if debug:
		draw_line(
			Vector2(hLimits.x, vLimits.x), 
			Vector2(hLimits.y, vLimits.x), 
			Color.SPRING_GREEN)
		draw_line(
			Vector2(hLimits.x, vLimits.y), 
			Vector2(hLimits.y, vLimits.y), 
			Color.SPRING_GREEN)
		draw_line(
			Vector2(hLimits.x, vLimits.x), 
			Vector2(hLimits.x, vLimits.y), 
			Color.SPRING_GREEN)
		draw_line(
			Vector2(hLimits.y, vLimits.x), 
			Vector2(hLimits.y, vLimits.y), 
			Color.SPRING_GREEN)
