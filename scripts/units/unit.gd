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


const MAX_SCALE = 1.5

## Animations
@onready var love_fx = $LoveParticles3D
@onready var collision_shape : CollisionShape3D = $CollisionShape3D  # Adjust the path if necessary
# crab, cat, and onion spine sprite 3ds
@onready var crab_spine_sprite : SpineSprite = $CrabSpineSprite3D/SubViewport/SpineSprite
@onready var cat_spine_sprite : SpineSprite = $CatSpineSprite3D/SubViewport/SpineSprite
@onready var onion_spine_sprite : SpineSprite = $OnionSpineSprite3D/SubViewport/SpineSprite

@onready var crab_sprite3d : Sprite3D = $CrabSpineSprite3D/Sprite3D
@onready var spine_sprite : SpineSprite 

# dialog box
@onready var dialog_box : Sprite3D = $DialogBoxSprite3D
@onready var dialog_box_label : Label3D = $DialogBoxSprite3D/Label3D
# interactions:
# stub toe on rocks (collide with object)
# kiss (collide with other unit)
# react to player (clicked on)
var personality_data = {
	"name" : "",
	"unit_type": -1,
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


	unit_clicked.connect(pretty_print_personality)
	randomize_personality()


	spine_sprite.get_animation_state().add_animation("sad",2,true,1)

	dialog_box.hide()

	update_skeleton_scale()


func _process(delta):
	# Apply gravity
	velocity += Vector3.DOWN * 9.8 * delta
	
	# Update current state
	current_state.update(delta)

	# process collisions
	if !busy:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			handle_collision(collision)
	
	move_and_slide()

func update_skeleton_scale():
	if spine_sprite == null:
		return
	var skeleton : SpineSkeleton = spine_sprite.get_skeleton()
	# var spine_skin := skeleton.get_skin()
	# spine_skin.
	# var rl := skeleton.get_attachment_by_slot_name("right leg", "right leg")
	skeleton.get_root_bone().set_scale_x(clamp(MAX_SCALE * personality_data["stats"][UGC.StatPrimitives.HEALTH], 0.3, MAX_SCALE))
	skeleton.get_root_bone().set_scale_y(clamp(MAX_SCALE * personality_data["stats"][UGC.StatPrimitives.HEALTH], 0.3, MAX_SCALE))

func randomize_personality():
	personality_data["name"] = UGC.list_of_names[randi() % UGC.list_of_names.size()]

	# Randomize unit type based on UnitTypes
	personality_data["unit_type"] = UGC.UnitTypes.values()[randi() % UGC.UnitTypes.values().size()]

	# Randomize stats
	for stat in UGC.StatPrimitives.values():
		personality_data["stats"][stat] = randf_range(-1, 1)


	## implement unit type bias - cats are social, onions are healthy, and crabs are hungry
	var unit_type = personality_data["unit_type"]
	var stats = personality_data["stats"]

	var is_web = OS.has_feature("web")

	if unit_type == UGC.UnitTypes.CAT:
		# cats are social bias
		stats[UGC.StatPrimitives.SOCIAL] = 0.2
		#
		cat_spine_sprite.get_parent().get_parent().show()
		# FIXME temporary hide the sprite
		var subviewport : SubViewport = cat_spine_sprite.get_parent()
		subviewport.size = Vector2(0,0)
		spine_sprite = cat_spine_sprite
		print('displaying cat')
		# onion_spine_sprite.queue_free()
		# crab_spine_sprite.queue_free()
	if unit_type == UGC.UnitTypes.ONION:
		stats[UGC.StatPrimitives.HEALTH] = 0.2
		onion_spine_sprite.get_parent().get_parent().show()
		# FIXME temporary hide the sprite
		var subviewport : SubViewport = onion_spine_sprite.get_parent()
		subviewport.size = Vector2(0,0)
		spine_sprite = onion_spine_sprite
		print('displaying onion')
		# cat_spine_sprite.queue_free()
		# crab_spine_sprite.queue_free()
	if unit_type == UGC.UnitTypes.CRAB:
		stats[UGC.StatPrimitives.HUNGER] = 0.2
		crab_spine_sprite.get_parent().get_parent().show()
		spine_sprite = crab_spine_sprite
		print('displaying crab')
		# onion_spine_sprite.queue_free()
		# cat_spine_sprite.queue_free()


func pretty_print_personality():
	busy = true
	# try godot manager
	var stats = "I'm " + personality_data["name"] + " the "  + pretty_print_unit_type_to_string(personality_data["unit_type"]) + "\n" 
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

	stats += "my highest stat is: " + pretty_print_trait_to_string(max_stat) + " at " + str(round_to_dec(personality_data["stats"][max_stat], 2)) + "\n"
	
	for stat in UGC.StatPrimitives.values():
		if stat != max_stat:
			stats += pretty_print_trait_to_string(stat) + ": " + str(round_to_dec(personality_data["stats"][stat], 2)) + "\n"

	dialog_box_label.text = stats
	dialog_box.show()
	change_state(idle_state)

	# wait 8 seconds, then hide the dialogue box
	await get_tree().create_timer(4.0).timeout
	dialog_box.hide()
	busy = false

	# print("Name: ", personality_data["name"])
	# print("Type: ", personality_data["unit_type"])
	# print("Stats: ")
	# for stat in UGC.StatPrimitives.values():
	# 	print(pretty_print_trait_to_string(stat), ": ", personality_data["stats"][stat])

## https://forum.godotengine.org/t/how-to-round-to-a-specific-decimal-place/27552/3?u=carlosmichael
## round_to_dec(1.352, 2) #rounds to the 2nd decimal digit. 1.35
func round_to_dec(num : float, digit : int):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

	

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
		



## adjust stat function
func adjust_stat(stat: UGC.StatPrimitives, amount: float):
	personality_data["stats"][stat] += amount
	# clamp to -1 to 1
	personality_data["stats"][stat] = clampf(personality_data["stats"][stat], -1.0, 1.0)
	# print(personality_data["stats"])
	update_skeleton_scale()

func handle_collision(collision: KinematicCollision3D):
	var collider = collision.get_collider()
	if collider == null:
		return
	if collider.is_in_group("rocks"):
	# 	# stub toe on rocks
		print("ouch")
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

	const KISS_LIMIT = 2
	var kiss_count = 0

	func enter():
		if unit.busy:
			return
		unit.velocity = Vector3.ZERO
		unit.busy = true
		kiss_count += 1
		if kiss_count >= KISS_LIMIT:
			unit.change_state(unit.idle_state)
			return
		# print("Entering Kiss State")
		unit.love_fx.emitting = true
		if unit.spine_sprite != null:
			unit.spine_sprite.get_animation_state().set_animation("happy",true,0)
		# adjust stat for happiness by + 0.1
		# adjust stat for social by + 0.2
		unit.adjust_stat(UGC.StatPrimitives.HEALTH, 0.3)
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
