extends Node
class_name GameStateMachine

@onready var game_ui : GameUI = get_node("/root/Game/CanvasLayer/GameUI")

@onready var game_scene = get_node("/root/Game/World3D/Scene")
@export var unit_base : PackedScene

# global timer to track lifespan of units

const MAX_UNITS = 5
var currently_spawned_units : Array[Unit] = []

@onready var stateful_objectives = UGC.list_of_objectives.duplicate(true)

# add button

func _ready():
	game_ui.submit_button.pressed.connect(check_objective_completion)

	# game_ui.add_button.pressed.connect(instantiate_unit)
	game_ui.update_all_labels()
	instantiate_unit()
	await get_tree().create_timer(1.0).timeout
	instantiate_unit()
	await get_tree().create_timer(1.0).timeout
	instantiate_unit()

func check_objective_completion() -> Array[Unit]:
	var units : Array[Unit]= []
	for i in range(stateful_objectives.size()-1):
		if stateful_objectives[i]["completed"] == false:
			var unit = _check_specific_objective_completion(i)
			if unit != null:
				units.append(unit)

	# removing units from list during for loop not supported?
	# if units[0]:
		# currently_spawned_units.erase(unit)
		# unit.queue_free()
	return units
	

func _check_specific_objective_completion(objective_index : int) -> Unit:
	# each objective has a type, trait, and target value
	# look through the list of units, and check if the objective is complete by finding untis of that type, and checking that trait's value
	var objective = stateful_objectives[objective_index]["objective"]
	for unit in currently_spawned_units:
		if unit.personality_data["unit_type"] == objective["unit_type"]:
			if unit.personality_data["stats"][objective["trait"]] >= objective["target"]:
				print("Objective complete!")
				game_ui.objective_to_label(objective_index).text = "Objective Complete!"
				stateful_objectives[objective_index]["completed"] = true
				return unit
	return null


func affect_all_unit_event(trait_affected : UGC.StatPrimitives, amount : float):
	for unit in currently_spawned_units:
		unit.personality_data["stats"][trait_affected] += amount

func instantiate_unit():
	if currently_spawned_units.size() >= MAX_UNITS:
		print("Can't spawn more units! At limit: " + str(MAX_UNITS))
		return
	var unit = unit_base.instantiate()
	game_scene.add_child(unit)
	unit.global_transform.origin = Vector3(0, randi_range(3,6), 0)
	currently_spawned_units.append(unit)
