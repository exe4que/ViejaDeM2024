extends Entity


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	#EntitiesManager.add_entity(self)

func can_interact_short():
	return true
	
func can_interact_long():
	return true

func interact_short(entity):
	print(self.name + " interacted short")

func interact_long(entity):
	print(self.name + " interacted long")

func die():
	EntitiesManager.remove_entity(self)
	await get_tree().create_timer(0.2).timeout
	queue_free()
