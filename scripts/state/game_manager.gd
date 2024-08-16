extends Node
class_name GameStateMachine

# enum GameStates {
# 	INIT,
# 	PREP,
# 	TURN_EXECUTION,
# 	GAME_END
# }

# var current_state : GameState

# var players : Array[Player] = []
# var client_player : Player

# var states = {}


# ## TODO : add a "UI Service" that will handle all the UI stuff. ew.
# @onready var phase_label_ui: Label = get_node("/root/HexGridScene/CanvasLayer/Control/GameState/HBoxContainer/Label")
# @onready var time_left_label_ui: Label = get_node("/root/HexGridScene/CanvasLayer/Control/GameState/HBoxContainer2/Label")
# @onready var turn_resolution_label_ui: Label = get_node("/root/HexGridScene/CanvasLayer/Control/GameState/HBoxContainer3/Label")
# @onready var player_state_top_ui: Label = get_node("/root/HexGridScene/CanvasLayer/Control/PlayerState/HBoxContainer/Label")
# @onready var player_state_bottom_ui: Label = get_node("/root/HexGridScene/CanvasLayer/Control/PlayerState/HBoxContainer2/Label")

# @onready var move_command_button :Button= get_node("/root/HexGridScene/CanvasLayer/Control/PlayerState/Commands/Button")
# @onready var place_unit_command_button:Button = get_node("/root/HexGridScene/CanvasLayer/Control/PlayerState/Commands/Button2")

# ## TODO : sync on game design rules, this is temporary / placeholder, but here to show a separated manager system
# # @onready var shop_manager : ShopManager = get_node("/root/HexGridScene/Services/ShopManager") 

# ## TODO : should this be in the _init function, then transition_to is the only thing in _ready?
# func _ready() -> void:
# 	states[GameStates.INIT] = InitState.new(self)
# 	states[GameStates.PREP] = PrepState.new(self)
# 	states[GameStates.TURN_EXECUTION] = TurnExecutionState.new(self)
# 	## FIXME : some race conditions with other nodes here, since the states require the different components to be initialized, since i have been initializing everything in _ready, its like the Awake vs Start of Godot, and all the states stuff rn is in Start. I think this is probably in issue in a couple classes...
# 	transition_to(GameStates.INIT)
# 	pass

# func transition_to(state_enum : GameStates) -> void:
# 	if current_state:
# 		current_state.exit()
	
# 	current_state = states[state_enum]
# 	current_state.enter()

# func _process(delta: float) -> void:
# 	current_state.process(delta)
