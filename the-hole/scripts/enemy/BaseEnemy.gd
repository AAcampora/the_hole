extends Node

class_name BaseEnemy

# this class is the boilerplate of behaviours for our enemies.
# it has to handle a couple of things:
# the movement of the enemy
# the sound and type of the enemy 
# For the movement whe can follow the behaviour that Scott Cawthon uses with the "movement chances"
# the difficulty controlling how many chances they get

# difficulty will dicate how much a specific behaviour will happen
# difficulty goes from 1 to 20
@export var _difficulty: int = 1
@export var _actTime: int = 5
const CHALLENGE_LEVEL : int = 20

var _actTimer: Timer;

func _ready() -> void:
	_actTimer = Timer.new()
	_actTimer.wait_time = _actTime;
	add_child(_actTimer)
	_actTimer.timeout.connect(_moveToNextNode)
	_actTimer.start()

# for now we move only, but in other enemie it might be worth it to do something else as well
func _moveToNextNode() -> void:
	# check if we have an opportunity to move
	_actTimer.stop()
	
	if _canDoAction(): 
		print("enemy moved!")
		_actTimer.start()
	else:
		print("enemy failed to move")
		_actTimer.start()

func _canDoAction() -> bool:
	# difficulty 1
	# challenge level is fixed at 20
	# difficulty lowers the challenge level down
	# therefore 20 - 1 = 19
	# now random * challenge level. if rand floor num = challenge level, return true.
	# else, do nothing and trigger the timer again
	
	var _challenge_level = CHALLENGE_LEVEL - _difficulty
	var _enemyAttempt = randi_range(1, _challenge_level)
	return _enemyAttempt >= _challenge_level
	
