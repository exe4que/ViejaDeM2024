extends Control

func _on_start_button_button_down():
	$ColorRect2/AnimationPlayer.play("main_menu_fade_out")
	$VBoxContainer/StartButton.hide()
	$VBoxContainer/QuitButton.hide()
	$VBoxContainer/ControlsButton.hide()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/transition_screen.tscn")
	
	
