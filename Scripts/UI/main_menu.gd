extends Control

func _process(delta):
	return
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/escena.tscn")
	print("start")
