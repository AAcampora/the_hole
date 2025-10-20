extends Control

@export var buttons_pairs: Array[ButtonPanelPair]

var buttons = {}

func _ready():
	for pair in buttons_pairs:
		var button: Button = get_node(pair.button)
		var panel: Panel = get_node(pair.panel)
		buttons[button] = panel
		
	for btn in buttons.keys():
		btn.pressed.connect(_on_button_pressed.bind(btn))

	reset()
		
func _on_button_pressed(button: Button): 
	if buttons.has(button):
		var target_panel = buttons[button]
		target_panel.visible = true
	
func reset():
	for item in buttons:
		buttons[item].visible = false;
