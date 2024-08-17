extends Node
class_name GameStateMachine

@onready var game_ui : GameUI = get_node("/root/Game/CanvasLayer/GameUI")

@onready var game_scene = get_node("/root/Game/World3D/Scene")
@export var unit_base : PackedScene

# add button

func _ready():
	game_ui.add_button.pressed.connect(instantiate_unit)
	game_ui.update_all_labels("")

func instantiate_unit():
	var unit = unit_base.instantiate()
	game_scene.add_child(unit)
	unit.global_transform.origin = Vector3(0, 4, 0)
