extends Control
class_name WindowApp

signal request_minimize(window: Control)
signal request_close(window: Control)

@export var close_button: Button
@export var minimise_button: Button

@export var window_title := "Untitled"
@export var window_icon: Texture2D

var desktop: DesktopApp = null

var dragging := false
var drag_offset := Vector2.ZERO

func _ready():
	close_button.pressed.connect(_on_close_pressed)
	minimise_button.pressed.connect(_on_minimise_pressed)
	set_meta("window_title", window_title)
	set_meta("window_icon", window_icon)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = get_global_mouse_position() - global_position
			move_to_front()
		else:
			dragging = false

	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset

	# Clamp within viewport
	var viewport_size = get_viewport_rect().size
	global_position.x = clamp(global_position.x, 0, viewport_size.x - size.x)
	global_position.y = clamp(global_position.y, 0, viewport_size.y - size.y)

func _on_close_pressed():
	_close_animation()

func _on_minimise_pressed():
	_minimise_animation()

func _close_animation():
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0, 0.1)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.1)
	tween.finished.connect(func():
		emit_signal("request_close", self)
		queue_free()
	)

func _minimise_animation():
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(0.8, 0.8), 0.1)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.1)
	tween.finished.connect(func():
		visible = false
		emit_signal("request_minimize", self)
	)

func restore_animation():
	visible = true
	modulate.a = 0
	scale = Vector2(0.8, 0.8)
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.15)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.15)
