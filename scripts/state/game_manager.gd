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
	instantiate_unit()
	instantiate_unit()



func init_buttons():
	game_ui.button.pressed.connect(throw_rock)
	game_ui.button2.pressed.connect(throw_skull)
	game_ui.button3.pressed.connect(make_it_rain)
	game_ui.button4.pressed.connect(make_it_reign)
	game_ui.button5.pressed.connect(optional)
	game_ui.button6.pressed.connect(party_time)
	game_ui.button7.pressed.connect(drama)
	game_ui.button8.pressed.connect(new_album)

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
	if units.size() > 0:
		for unit in units:
			# find each index of unit in the list of currently spawned units
			var index = currently_spawned_units.find(unit)
			unit.queue_free()
			if index != -1:
				currently_spawned_units.remove_at(index)

			instantiate_unit()
		# currently_spawned_units.erase(units[0])
		# units[0].queue_free()
	return units
	

func _check_specific_objective_completion(objective_index : int) -> Unit:
	# each objective has a type, trait, and target value
	# look through the list of units, and check if the objective is complete by finding untis of that type, and checking that trait's value
	var objective = stateful_objectives[objective_index]["objective"]
	for unit in currently_spawned_units:
		if unit.personality_data["unit_type"] == objective["unit_type"]:
			if unit.personality_data["stats"][objective["trait"]] >= objective["target"]:
				game_ui.objective_to_label(objective_index).text = unit.personality_data["name"] + "completed the objective!"
				stateful_objectives[objective_index]["completed"] = true
				return unit
	return null


func affect_all_unit_event(trait_affected : UGC.StatPrimitives, amount : float):
	for unit in currently_spawned_units:
		unit.adjust_stat(trait_affected, amount)

func throw_rock():
	# instantiate rock
	pass

func throw_skull():
	# instantiate skull
	pass

func make_it_rain():
	# instantiate particle fx
	pass

func make_it_reign():
	affect_all_unit_event(UGC.StatPrimitives.HAPPINESS, -.1)
	affect_all_unit_event(UGC.StatPrimitives.SOCIAL, -.5)
	affect_all_unit_event(UGC.StatPrimitives.HUNGER, .7)
	pass

func optional():

	pass

func party_time():
	affect_all_unit_event(UGC.StatPrimitives.SOCIAL, .1)
	pass

func drama():
	affect_all_unit_event(UGC.StatPrimitives.HAPPINESS, -.5)
	pass

func new_album():
	affect_all_unit_event(UGC.StatPrimitives.HAPPINESS, .5)
	pass

func instantiate_unit():
	if currently_spawned_units.size() >= MAX_UNITS:
		print("Can't spawn more units! At limit: " + str(MAX_UNITS))
		return
	var unit = unit_base.instantiate()
	game_scene.add_child(unit)
	unit.global_transform.origin = Vector3(0, randi_range(3,6), 0)
	currently_spawned_units.append(unit)
