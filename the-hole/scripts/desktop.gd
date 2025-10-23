extends Control
class_name DesktopApp

@export var panel_container: Control
@export var creatures_button: Button
@export var handbook_button: Button
@export var taskBar: TaskBar

var buttons = {}
var open_windows = {}  # title -> window instance

func _ready():
	buttons = {
		creatures_button: preload("res://prefab/window_creatures.tscn"),
		handbook_button: preload("res://prefab/window_handbook.tscn")
	}

	for btn in buttons.keys():
		btn.pressed.connect(_on_button_pressed.bind(btn))

	taskBar.tab_pressed.connect(_on_tab_pressed)

func _on_button_pressed(button: Button):
	var panel_scene: PackedScene = buttons[button]
	var scene_path = panel_scene.resource_path

	# Check if already open or minimized
	for title in open_windows.keys():
		var win = open_windows[title]
		if win.scene_file_path == scene_path:
			if not win.visible:
				_restore_window(title)
			return

	# Create new window
	var window: WindowApp = panel_scene.instantiate()
	window.desktop = self
	panel_container.add_child(window)

	# Hook up signals
	window.request_minimize.connect(_on_window_minimize)
	window.request_close.connect(_on_window_close)

	open_windows[window.window_title] = window

	# Animate entry
	window.scale = Vector2(0.2, 0.2)
	window.modulate.a = 0
	var tween = create_tween()
	tween.parallel().tween_property(window, "modulate:a", 1.0, 0.25)
	tween.parallel().tween_property(window, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_window_minimize(window: WindowApp):
	taskBar.add_tab(window)
	panel_container.remove_child(window)

func _on_window_close(window: WindowApp):
	var title = str(window.window_title)
	if open_windows.has(title):
		open_windows.erase(title)
	taskBar.remove_tab(title)

func _on_tab_pressed(title: String):
	_restore_window(title)

func _restore_window(title: String):
	if not open_windows.has(title):
		return
	var window = open_windows[title]
	panel_container.add_child(window)
	taskBar.remove_tab(title)
	window.restore_animation()
