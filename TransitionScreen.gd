extends CanvasLayer

#signal transitioned

func _ready():
	transition()

func transition():
	$ColorRect/AnimationPlayer.play("fade_to_normal")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_normal":
		emit_signal("transitioned")
		await get_tree().create_timer(2.0).timeout
		$ColorRect/AnimationPlayer.play("fade_to_black")
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Scenes/escena.tscn")
