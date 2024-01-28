extends CanvasLayer

@export var levelWonPanel: CanvasModulate
@export var levelLostPanel: CanvasModulate

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalManager.level_lost.connect(_onLevelLost)
	GlobalManager.level_won.connect(_onLevelWon)

func _onLevelWon():
	levelWonPanel.show()
	get_tree().create_tween().tween_property(levelWonPanel, "color", Color.WHITE, 1)
	
func _onLevelLost():
	levelLostPanel.show()
	get_tree().create_tween().tween_property(levelLostPanel, "color", Color.WHITE, 1)



func _on_button_button_down():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
