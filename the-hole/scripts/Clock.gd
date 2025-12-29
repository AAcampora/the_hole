extends Node

const MAX_TIME: int = 6
const SECONDS_PER_HOUR = 120

@export var  current_time: int = 0

var _timer : Timer

signal hour_changed(current_hour)
signal time_finished

func _ready() -> void:
	_timer = Timer.new()
	_timer.wait_time = SECONDS_PER_HOUR
	_timer.one_shot = false
	add_child(_timer)
	
	_timer.timeout.connect(_on_hour_passed)
	
func _on_hour_passed():
	current_time += 1
	emit_signal("hour_changed", current_time)
	
	# handle reaching end of time
	if current_time >=MAX_TIME: 
		emit_signal("time_finished")
		_stop_clock()	
		
func _stop_clock():
	if _timer: 
		_timer.stop()

func _reset_clock():
	current_time = 0
	_timer.start()
