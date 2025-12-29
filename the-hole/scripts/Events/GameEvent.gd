extends Resource
class_name GameEvent

@export var hour_trigger : int
@export var description: String

func trigger(game_manager : Node) -> void: 
	print("base Game event triggered: ", description)
