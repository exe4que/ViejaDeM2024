extends ProgressBar
@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = Time.get_ticks_usec() / 1000000
	var timeLeft = GlobalManager.endTimestamp - time
	var duration: float = GlobalManager.gameDuration
	print("time left: " + str(timeLeft) + "/ duration: " + str(duration))
	var progress = timeLeft / duration
	progress = clampf(progress, 0, 1)
	var progressPercent = progress * 100
	value = progressPercent
	
	label.set_text("PLAY TIME REMAINING: " + str(timeLeft))
	pass
