extends CharacterBody3D
class_name Unit


## Signals
signal unit_clicked

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

# interactions:
# stub toe on rocks (collide with object)
# kiss (collide with other unit)
# react to player (clicked on)
var personality_data = {
	"name" : "",
	"stats": {
		# [-1 to 1]
		"health": 0,
		"hunger": 0,
		"social": 0,
		"happiness": 0
	}
}


func _ready():
	idle_state = IdleState.new(self)
	move_state = MoveState.new(self)
	kiss_state = KissState.new(self)
	
	current_state = idle_state
	current_state.enter()

	input_ray_pickable = true

	spine_sprite.get_animation_state().add_animation("sad",2,true,1)


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

func handle_collision(collision: KinematicCollision3D):
	var collider = collision.get_collider()
	# if collider is StaticBody3D and collider.is_in_group("rocks"):
	# 	# stub toe on rocks
	if collider.is_in_group("unit"): 
		change_state(kiss_state)

func change_state(new_state: State):
	current_state.exit()
	current_state = new_state
	current_state.enter()

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

# Idle State
class IdleState extends State:
	func enter():
		# print("Entering Idle State")
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
		# print("Entering Kiss State")
		unit.love_fx.emitting = true
		unit.spine_sprite.get_animation_state().set_animation("happy",true,0)

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


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# print("Input event received on ", name)  # Debug print
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Clicked on Unit: ", name, " at position: ", position)
		unit_clicked.emit(self)