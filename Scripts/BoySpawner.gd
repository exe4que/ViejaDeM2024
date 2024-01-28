extends Node2D
@export var spawnFrecuencyStart: float = 7
@export var spawnFrecuencyEnd: float = 2

var currentSpawnFrecuency = 7
var ballRes = preload("res://Scenes/ball.tscn")
var boyRes = preload("res://Scenes/pibe.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	currentSpawnFrecuency = spawnFrecuencyStart

	while GlobalManager.running:
		var hLimits = GlobalManager.horizontallLimits
		var vLimits = GlobalManager.verticalLimits
		var randX = randf_range(hLimits.x + 50, hLimits.y - 50)
		var randZ = randf_range(vLimits.x + 50, vLimits.y - 50)
		var newPos = Vector3(randX, 0, randZ)
		
		var newBall = ballRes.instantiate()
		add_child(newBall)
		newBall.initialize(newPos)
		ballSound()
		
		var newBoy = boyRes.instantiate()
		add_child(newBoy)
		newBoy.initialize(newBall)
		
		await get_tree().create_timer(currentSpawnFrecuency).timeout

func ballSound():
	await get_tree().create_timer(1).timeout
	$BallAudio.play()
	await get_tree().create_timer(1,95).timeout
	$BallAudio.play()
	await get_tree().create_timer(0.7).timeout
	$BallAudio.play()
	await get_tree().create_timer(0.3).timeout
	$BallAudio.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	currentSpawnFrecuency = lerpf(spawnFrecuencyStart, spawnFrecuencyEnd, GlobalManager.progress)
