extends Entity


# Called when the node enters the scene tree for the first time.
func _ready():
	EntitiesManager.add_entity(self)

