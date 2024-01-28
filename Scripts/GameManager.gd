extends Node2D

@export var verticalLimits: Vector2 = Vector2(380, 700)
@export var horizontallLimits: Vector2 = Vector2(0, 1152)

signal level_won()
signal level_lost()

#3 * 60 = 3min
var gameDuration = 3 * 60
var running = true
var endTimestamp = 0

func start():
	running = true
	var time = Time.get_ticks_usec() / 1000000
	endTimestamp = time + gameDuration

func _process(delta):
	if running:
		var time = Time.get_ticks_usec() / 1000000
		var timeLeft = endTimestamp - time
		if timeLeft <= 0:
			won()

func won():
	running = false
	level_won.emit()
	pass

func lost():
	running = false
	level_lost.emit()
	pass
