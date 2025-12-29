extends Node
class_name GameManager

@export var day_plans: Array[DayEvents]
@onready var clock = $GameClock

var current_day_index = 0

func _ready() -> void:
	# connect the clock so we can control our events
	clock.connect("hour_changed", Callable(self, "_on_hour_changed"))
	load_day(0)
	clock._reset_clock()
	_on_hour_changed(0)

# load the day required by the game	
func load_day(index: int):
	current_day_index = index;
	print("loaded day %s" % day_plans[index].day_number)
	
# at every hour, trigger an event
func _on_hour_changed(current_hour: int):
	var day_plan = day_plans[current_day_index]
	for event in day_plan.events:
		if event.hour_trigger == current_hour:
			_trigger_event(event)

func _trigger_event(event: GameEvent):
	print("triggered event: ", event.description)
			
