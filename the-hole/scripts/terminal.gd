extends Node2D
class_name Terminal

@export var input_text : LineEdit;
@export var output_text : TextEdit;

var prompt = "c://users/warden5458/> "
var caret_position : int
var command_history = []
var command_history_index: int = 0

var line_separator = "/------------------------------------------------------------------------------------------------------/"

var commands = {
	"SURFEED": {
		"desc": "Access live or archived surveillance feeds.",
		"usage": "SURFEED [CAM_ID]",
		"example": "SURFEED 02"
	},
	"GATECTRL": {
		"desc": "Control perimeter gates.",
		"usage": "GATECTRL [OPEN|CLOSE|STATUS] [ID]",
		"example": "GATECTRL OPEN A2"
	},
	"GASCTL": {
		"desc": "Regulate gas flow within tunnels 1–5.",
		"usage": "GASCTL [ENABLE|DISABLE] [TUNNEL_ID]",
		"example": "GASCTL ENABLE 3"
	},
	"POWCTRL": {
		"desc": "Manage remote power nodes.",
		"usage": "POWCTRL [ON|OFF|REBOOT] [NODE]",
		"example": "POWCTRL REBOOT NORTH_SUBGRID"
	},
	"EBLK": {
		"desc": "Activate emergency bulkhead lock systems.",
		"usage": "EBLK [ARM|DISARM|STATUS]",
		"example": "EBLK ARM"
	},
	"CLEAR": {
		"desc": "clear the console",
		"usage": "clear",
		"example": "clear"
	}
}

func _ready():
	input_text.text = prompt
	caret_position = prompt.length();
	
	input_text.connect("text_submitted", Callable(self, "_on_text_submitted"))
	input_text.connect("text_changed", Callable(self, "_on_text_changed"))

func _on_text_changed(new_text: String) -> void:
	caret_position = new_text.length()
	
func _on_text_submitted(new_text: String) -> void:
	var command = new_text.substr(prompt.length()).strip_edges()
	input_text.text = prompt;
	process_command(command)
	if command != command_history.front():
		command_history.push_front(command)

func process_command(cmd: String):
	var parts = cmd.strip_edges().split(" ")
	var base = parts[0].to_upper()
	var flag = parts[1].to_upper() if parts.size() > 1  else ""
	match base:
		"HELP":
			if flag == "-VERBOSE":
				print_verbose_help()
			if flag == "-V":
				print_verbose_help()
			else:
				print_basic_help()
		"CLEAR":
			clear_console()
		
		_:
			if flag == "--HELP":
				print_command_help(base)
			else:
				print_output("Unknown command. Type HELP for list of commands.")

#func _on_text_changed(new_text: String) -> void:
	#caret_position = input_text.text.length()
	
func clear_console():
	output_text.text =""
	output_text.scroll_vertical = 0
	
func print_basic_help():
	print_output("COMMAND INDEX - WARDEN OPS TERMINAL")
	print_output("FOR MORE INFORMATION, USE COMMAND: { HELP -VERBOSE } OR { HELP -V }")
	for k in commands.keys():
		print_output("%-12s | %s" % [k, commands[k]["desc"]])
	
func print_verbose_help():
	print_output(line_separator)
	print_output("COMMAND INDEX - WARDEN OPS TERMINAL (VERBOSE MODE)\n>")
	for k in commands.keys():
		var cmd = commands[k]
		print_output(k)
		print_output(cmd["desc"])
		print_output("Usage: " + cmd["usage"])
		print_output("Example: " + cmd["example"])
		print_output(line_separator)
	
func print_command_help(command: String): 
	print_output("COMMAND INDEX - WARDEN OPS TERMINAL - DEFINE COMMAND: %s\n>" %[command])
	var cmd = commands[command]
	print_output(cmd["desc"])
	print_output("Usage: " + cmd["usage"])
	print_output("Example: " + cmd["example"])
	print_output(line_separator)
			
func print_output(text: String):
	output_text.text += ">    " + text + "\n"
	output_text.scroll_vertical += output_text.get_line_count()
	
func reset_input():
	input_text.text = prompt + " "
	input_text.caret_column = prompt.length() + 1
	
func scroll_history(is_down: bool):
	if command_history.size() != 0:
		var history = command_history[command_history_index]
		var history_size =  command_history.size() -1
		input_text.text = prompt + " " + history
		
		if is_down:
			command_history_index = command_history_index - 1 if command_history_index > history_size else 0
		else:
			command_history_index = command_history_index + 1 if command_history_index <  history_size else history_size
	
	print(input_text.caret_column)	

func _input(event):
	# Prevent backspace deleting the prompt
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_BACKSPACE and caret_position <= prompt.length():
			reset_input()
		if event.keycode == KEY_UP:
			scroll_history(false)
			input_text.caret_column = input_text.text.length()
		if  event.keycode == KEY_DOWN:
			scroll_history(true)
			input_text.caret_column = input_text.text.length()
	
