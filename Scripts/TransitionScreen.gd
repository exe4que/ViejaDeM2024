extends CanvasLayer

signal transitioned

func _ready():
	transition()

func transition():
	$AnimationPlayer.play("fade_to_black")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		print("fadetoblack")
		emit_signal("transitioned")
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play("fade_to_normal")	
	if anim_name == "fade_to_normal":
		print("fade to normal")
