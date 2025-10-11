extends Node2D
class_name Terminal

@export var input_text : LineEdit;
@export var output_text : TextEdit;

@onready var surfeed: SURFEED = $CanvasLayer/Container;

var caret_position : int
var command_history = []
var command_history_index: int = 0
const Texts = preload("res://Data/translations/terminal_text_en.gd")

func _ready():
	input_text.text = Texts.PROMPT
	caret_position = Texts.PROMPT.length();
	
	input_text.connect("text_submitted", Callable(self, "_on_text_submitted"))
	input_text.connect("text_changed", Callable(self, "_on_text_changed"))

func _on_text_changed(new_text: String) -> void:
	caret_position = new_text.length()
	
func _on_text_submitted(new_text: String) -> void:
	var command = new_text.substr(Texts.PROMPT.length()).strip_edges()
	input_text.text = Texts.PROMPT;
	process_command(command)
	if command_history.is_empty() or command != command_history.front():
		command_history.push_front(command)

func process_command(cmd: String):
	var parts = cmd.strip_edges().split(" ")
	var base = parts[0].to_upper()
	var flag = parts[1].to_upper() if parts.size() > 1  else ""
	match base:
		"HELP":
			if flag in ["-V", "-VERBOSE"]: 
				print_verbose_help()
			else:
				print_basic_help()
		"CLEAR":
			clear_console()
		"SURFEED":
			activate_surveliance_feed(flag)
			
		_:
			if Texts.COMMANDS.has(base):
				if flag == "--HELP":
					print_command_help(base)
			else:
				print_output(Texts.UKNOWN_COMMAND)

#func _on_text_changed(new_text: String) -> void:
	#caret_position = input_text.text.length()
	
func clear_console():
	output_text.text =""
	output_text.scroll_vertical = 0
	
func activate_surveliance_feed(camera_ID: String):
	surfeed._activate_feed(camera_ID)
	
	
func print_basic_help():
	print_output(Texts.COMAND_INDEX_GREETING)
	print_output(Texts.COMMAND_INDEX_MORE_INFO)
	for k in Texts.COMMANDS.keys():
		print_output("%-12s | %s" % [k, Texts.COMMANDS[k]["desc"]])
	print_output(Texts.LINE_SEPARATOR)
	
func print_verbose_help():
	print_output(Texts.COMAND_INDEX_GREETING_VERBOSE)
	for k in Texts.COMMANDS.keys():
		var cmd = Texts.COMMANDS[k]
		print_output(k)
		print_output(cmd["desc"])
		print_output(Texts.HELP_SECTION_P1 + cmd["usage"])
		print_output(Texts.HELP_SECTION_P2 + cmd["example"])
		print_output(Texts.LINE_SEPARATOR)
	
func print_command_help(command: String): 
	print_output(Texts.COMMAND_INDEX_DEFINE %[command])
	var cmd = Texts.COMMANDS[command]
	print_output(cmd["desc"])
	print_output(Texts.HELP_SECTION_P1 + cmd["usage"])
	print_output(Texts.HELP_SECTION_P2 + cmd["example"])
	print_output(Texts.LINE_SEPARATOR)
			
func print_output(text: String):
	output_text.text += ">    " + text + "\n"
	output_text.scroll_vertical += output_text.get_line_count()
	
func reset_input():
	input_text.text = Texts.PROMPT + " "
	input_text.caret_column = Texts.PROMPT.length() + 1
	
func scroll_history(is_down: bool):
	if command_history.is_empty():
		return
	
	command_history_index = clamp(
		command_history_index + (1 if not is_down else -1),
		0, command_history.size() - 1
	)
	input_text.text = Texts.PROMPT + command_history[command_history_index]
	input_text.caret_column = input_text.text.length()

func _input(event):
	# Prevent backspace deleting the prompt
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_BACKSPACE and caret_position <= Texts.PROMPT.length():
			reset_input()
		if event.keycode == KEY_UP:
			scroll_history(false)
			input_text.caret_column = input_text.text.length()
		if  event.keycode == KEY_DOWN:
			scroll_history(true)
			input_text.caret_column = input_text.text.length()
	
