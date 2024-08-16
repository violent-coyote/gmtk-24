extends Resource
class_name GameState

var _game_state_machine : GameStateMachine

func _init(game_state_machine : GameStateMachine) -> void:
	_game_state_machine = game_state_machine

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(delta : float) -> void:
	pass