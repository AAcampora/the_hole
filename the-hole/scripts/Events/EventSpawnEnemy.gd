extends GameEvent
class_name EventSpawnEnemy

@export var enemy_scene: PackedScene
@export var spawn_position: Vector2

func trigger(game_manager : Node) -> void:
	print("Spawning enemy: ", description)
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_position
		game_manager.get_tree().root.add_child(enemy)
