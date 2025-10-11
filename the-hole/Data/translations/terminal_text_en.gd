extends Resource

class_name  TerminalText

const PROMPT = "c://users/warden369/> "
const  LINE_SEPARATOR = "/------------------------------------------------------------------------------------------------------/"
const UKNOWN_COMMAND = "Unknown command. Type HELP for list of commands."
const COMAND_INDEX_GREETING = "COMMAND INDEX - WARDEN OPS TERMINAL"
const COMAND_INDEX_GREETING_VERBOSE = "COMMAND INDEX - WARDEN OPS TERMINAL (VERBOSE MODE)\n"
const COMMAND_INDEX_MORE_INFO = "FOR MORE INFORMATION, USE COMMAND: { HELP -VERBOSE } OR { HELP -V }"
const COMMAND_INDEX_DEFINE = "COMMAND INDEX - WARDEN OPS TERMINAL - DEFINE COMMAND: %s\n>"
const HELP_SECTION_P1 = "Usage: "
const HELP_SECTION_P2 = "Example: "
const COMMANDS = {
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
