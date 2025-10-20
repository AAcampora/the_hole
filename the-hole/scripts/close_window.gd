extends Panel
@export var button: Button
	
func _ready() -> void:
	button.pressed.connect(_close_window)

func _close_window(): 
	self.visible = false
