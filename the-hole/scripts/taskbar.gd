extends HBoxContainer
class_name TaskBar

signal tab_pressed(title: String)

var tab_instances := {}

func add_tab(window: Control):
	if tab_instances.size() >= 4:
		return

	var title = str(window.get_meta("window_title"))
	if tab_instances.has(title):
		return

	var tab_scene: PackedScene = preload("res://prefab/minimisedWindow.tscn")
	var tab_button: Button = tab_scene.instantiate()

	tab_button.text = title
	tab_button.icon = window.get_meta("window_icon")

	add_child(tab_button)
	tab_instances[title] = tab_button

	tab_button.pressed.connect(func(): emit_signal("tab_pressed", title))

func remove_tab(title: String):
	if not tab_instances.has(title):
		return
	var tab = tab_instances[title]
	if is_instance_valid(tab):
		tab.queue_free()
	tab_instances.erase(title)
