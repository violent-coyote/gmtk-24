extends CharacterBody3D
class_name Unit

# State Machine
var current_state: State

# States
var idle_state: IdleState
var move_state: MoveState
var kiss_state: KissState

var busy := false
@onready var love_fx = $LoveParticles3D
# interactions
# stub toe on rocks
# kiss if collide with another player



func _ready():
	idle_state = IdleState.new(self)
	move_state = MoveState.new(self)
	kiss_state = KissState.new(self)
	
	current_state = idle_state
	current_state.enter()

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
		print("Entering Idle State")
	
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
		print("Entering Move State")
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

	func enter():
		unit.velocity = Vector3.ZERO
		print("Entering Kiss State")
		unit.love_fx.emitting = true

	func exit():
		kiss_timer = 0.0
		unit.busy = false
		unit.love_fx.emitting = false
	
	func update(delta: float):
		if kiss_timer < KISS_DURATION:
			kiss_timer += delta
			unit.busy = true
		else:
			unit.change_state(unit.idle_state)
