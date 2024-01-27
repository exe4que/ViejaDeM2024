extends Entity


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	EntitiesManager.add_entity(self)

func can_interact_short():
	return true
	
func can_interact_long():
	return true

func interact_short(entity):
	print(self.name + " interacted short")

func interact_long(entity):
	print(self.name + " interacted long")
