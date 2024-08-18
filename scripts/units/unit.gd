extends CharacterBody3D
class_name Unit


## Signals
signal unit_clicked()

## State Machine
var current_state: State

## States
var idle_state: IdleState
var move_state: MoveState
var kiss_state: KissState

var busy := false


const MAX_SCALE = 15

## Animations
@onready var love_fx = $LoveParticles3D
@onready var collision_shape : CollisionShape3D = $CollisionShape3D  # Adjust the path if necessary
@onready var spine_sprite : SpineSprite = $SpineSprite3D/SubViewport/SpineSprite
@onready var dialog_box : Sprite3D = $DialogBoxSprite3D
@onready var dialog_box_label : Label3D = $DialogBoxSprite3D/Label3D
# interactions:
# stub toe on rocks (collide with object)
# kiss (collide with other unit)
# react to player (clicked on)
var personality_data = {
	"name" : "",
	"unit_type": UGC.UnitTypes.CRAB,
	"stats": {
		# [-1 to 1]
		UGC.StatPrimitives.HEALTH: 0,
		UGC.StatPrimitives.HUNGER: 0,
		UGC.StatPrimitives.SOCIAL: 0,
		UGC.StatPrimitives.HAPPINESS: 0,
	}
}



func _ready():
	randomize()
	idle_state = IdleState.new(self)
	move_state = MoveState.new(self)
	kiss_state = KissState.new(self)
	
	current_state = idle_state
	current_state.enter()

	input_ray_pickable = true

	spine_sprite.get_animation_state().add_animation("sad",2,true,1)

	unit_clicked.connect(pretty_print_personality)
	randomize_personality()
	dialog_box.hide()

	# var skeleton : SpineSkeleton = spine_sprite.get_skeleton()
	# var spine_skin := skeleton.get_skin()
	# spine_skin.
	# var rl := skeleton.get_attachment_by_slot_name("right leg", "right leg")
	# skeleton.get_root_bone().set_scale_x(MAX_SCALE)
	# skeleton.get_root_bone().set_scale_y(MAX_SCALE)
	# scale_slot("flame hair", MAX_SCALE)


func _process(delta):
	# Apply gravity
	velocity += Vector3.DOWN * 9.8 * delta
	
	# Update current state
	current_state.update(delta)

	# process collisions
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		handle_collision(collision)
	
	move_and_slide()

func randomize_personality():
	personality_data["name"] = UGC.list_of_names[randi() % UGC.list_of_names.size()]

	# Randomize stats
	for stat in UGC.StatPrimitives.values():
		personality_data["stats"][stat] = randf_range(-1, 1)

	add_unit_type_bias()

func pretty_print_personality():
	busy = true
	# try godot manager
	var stats = "Name: " + personality_data["name"] + "\n" + "Type: " + pretty_print_unit_type_to_string(personality_data["unit_type"]) + "\n" 
	# assemble descriptive string based on values of stats
	# find max stat
	var max_stat = UGC.StatPrimitives.HEALTH
	for stat in UGC.StatPrimitives.values():
		if personality_data["stats"][stat] > personality_data["stats"][max_stat]:
			max_stat = stat

	# stats += "Health: " + str(personality_data["stats"][UGC.StatPrimitives.HEALTH]) + "\n"
	# stats += "Hunger: " + str(personality_data["stats"][UGC.StatPrimitives.HUNGER]) + "\n"
	# stats += "Social: " + str(personality_data["stats"][UGC.StatPrimitives.SOCIAL]) + "\n"
	# stats += "Happiness: " + str(personality_data["stats"][UGC.StatPrimitives.HAPPINESS]) + "\n"

	stats += "my highest stat is: " + pretty_print_trait_to_string(max_stat) + " at " + str(personality_data["stats"][max_stat]) + "\n"
	dialog_box_label.text = stats
	dialog_box.show()
	change_state(idle_state)

	# wait 8 seconds, then hide the dialogue box
	await get_tree().create_timer(8.0).timeout
	dialog_box.hide()
	busy = false

	# print("Name: ", personality_data["name"])
	# print("Type: ", personality_data["unit_type"])
	# print("Stats: ")
	# for stat in UGC.StatPrimitives.values():
	# 	print(pretty_print_trait_to_string(stat), ": ", personality_data["stats"][stat])
func pretty_print_unit_type_to_string(unit_type: UGC.UnitTypes):
	match unit_type:
		UGC.UnitTypes.CAT:
			return "Cat"
		UGC.UnitTypes.ONION:
			return "Onion"
		UGC.UnitTypes.CRAB:
			return "Crab"

func pretty_print_trait_to_string(unit_trait: UGC.StatPrimitives):
	match unit_trait:
		UGC.StatPrimitives.HEALTH:
			return "Health"
		UGC.StatPrimitives.HUNGER:
			return "Hunger"
		UGC.StatPrimitives.SOCIAL:
			return "Social"
		UGC.StatPrimitives.HAPPINESS:
			return "Happiness"
		
## implement unit type bias - cats are social, onions are healthy, and crabs are hungry
func add_unit_type_bias():
	var unit_type = personality_data["unit_type"]
	var stats = personality_data["stats"]

	if unit_type == UGC.UnitTypes.CAT:
		stats[UGC.StatPrimitives.SOCIAL] = 0.8
	if unit_type == UGC.UnitTypes.ONION:
		stats[UGC.StatPrimitives.HEALTH] = 0.8
	if unit_type == UGC.UnitTypes.CRAB:
		stats[UGC.StatPrimitives.HUNGER] = 0.8


## adjust stat function
func adjust_stat(stat: UGC.StatPrimitives, amount: float):
	personality_data["stats"][stat] += amount
	# clamp to -1 to 1
	if personality_data["stats"][stat] > 1:
		personality_data["stats"][stat] = 1
	elif personality_data["stats"][stat] < -1:
		personality_data["stats"][stat] = -1

func handle_collision(collision: KinematicCollision3D):
	var collider = collision.get_collider()
	# if collider is StaticBody3D and collider.is_in_group("rocks"):
	# 	# stub toe on rocks
	if collider.is_in_group("unit"): 
		change_state(kiss_state)



func scale_slot(slot_name: String, scale_factor: float):
	var skeleton: SpineSkeleton = spine_sprite.get_skeleton()
	var spine_skin:= skeleton.get_skin()
	# Find the specified slot
	if spine_skin:
		var attachment_data := spine_skin.get_attachment(0, slot_name)
		if attachment_data:
			attachment_data.width *= scale_factor
			attachment_data.height *= scale_factor
			# attachment_data.scale_x = scale_factor
			# attachment_data.scale_y = scale_factor
			# skeleton.set_skin(spine_skin)
# region State Machine
# Base State class
class State:
	var unit: Unit
	
	func _init(_unit: Unit):
		unit = _unit
	
	func enter():
		pass
	
	func exit():
		pass
	
	func update(_delta: float):
		pass

func change_state(new_state: State):
	current_state.exit()
	current_state = new_state
	current_state.enter()

# Idle State
class IdleState extends State:
	func enter():
		# print("Entering Idle State")
		unit.velocity = Vector3.ZERO
		pass
	
	func update(_delta: float):
		# # Check for conditions to change state
		if unit.busy == false:
			unit.change_state(unit.move_state)
		# 	unit.change_state(unit.move_state)
		# elif unit.should_attack():
		# 	unit.change_state(unit.attack_state)

# Move State
class MoveState extends State:
	
	var patrol_area : Vector3 = Vector3(7,0,7)
	var patrol_target : Vector3 = Vector3(0,0,0)
	var patrol_speed : float = 2.0

	func get_random_patrol_point() -> Vector3:
		randomize()
		var x = randf_range(-patrol_area.x / 2, patrol_area.x / 2)
		var z = randf_range(-patrol_area.z / 2, patrol_area.z / 2)
		return Vector3(x, 0, z)

	func enter():
		# print("Entering Move State")
		patrol_target = get_random_patrol_point()
	
	func update(delta: float):
		var direction = (patrol_target - unit.global_transform.origin).normalized()
		unit.velocity = direction * patrol_speed
		
		# Check if we've reached the target
		if unit.global_transform.origin.distance_to(patrol_target) < 1.5:
			unit.change_state(unit.idle_state)

# Kiss State
class KissState extends State:
	# time to kiss
	const KISS_DURATION = 2.0
	var kiss_timer = 0.0

	var kiss_cooldown_timer = 0.0
	const KISS_COOLDOWN = 6.0

	func enter():
		unit.velocity = Vector3.ZERO
		unit.busy = true
		# print("Entering Kiss State")
		unit.love_fx.emitting = true
		unit.spine_sprite.get_animation_state().set_animation("happy",true,0)
		# adjust stat for happiness by + 0.1
		# adjust stat for social by + 0.2
		unit.adjust_stat(UGC.StatPrimitives.HAPPINESS, 0.1)
		unit.adjust_stat(UGC.StatPrimitives.SOCIAL, 0.2)


	func exit():
		kiss_timer = 0.0
		unit.busy = false
		unit.love_fx.emitting = false
		unit.spine_sprite.get_animation_state().set_animation("sad",true,0)
	
	func update(delta: float):
		if kiss_timer < KISS_DURATION:
			kiss_timer += delta
			unit.busy = true
		if kiss_cooldown_timer < KISS_COOLDOWN:
			kiss_cooldown_timer += delta
		else:
			unit.change_state(unit.idle_state)
# endregion

# region Input/Clicking on Unit
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# print("Input event received on ", name)  # Debug print
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not busy:
			print("Clicked on Unit: ", name, " at position: ", position)
			unit_clicked.emit()
# endregion
