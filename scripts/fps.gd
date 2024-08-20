extends CharacterBody3D
class_name Player

@export_subgroup("Properties")
@export var movement_speed = 5
@export var jump_strength = 8
@export var run_speed_amplifier : float = 1.8
var speed_increase : float = run_speed_amplifier

# @export_subgroup("Weapons")
# @export var weapons: Array[Weapon] = []

# var weapon: Weapon
var weapon_index := 0

var mouse_sensitivity = 700
var gamepad_sensitivity := 0.075

var mouse_captured := true

var movement_velocity: Vector3
var rotation_target: Vector3

var input_mouse: Vector2

var health:int = 100
var gravity := 0.0

var previously_floored := false

var jump_single := true
var jump_double := true

var container_offset = Vector3(1.2, -1.1, -2.75)

var tween:Tween

signal health_updated

@onready var camera = $Head/Camera3D
# @onready var raycast = $Head/RayCast3D
# @onready var muzzle = $Head/Camera/SubViewportContainer/SubViewport/CameraItem/Muzzle
# @onready var container = $Head/Camera3D/SubViewportContainer/SubViewport/MuzzleCam/Node3D
# @onready var sound_footsteps = $SoundFootsteps
# @onready var blaster_cooldown = $Cooldown

# @export var crosshair:TextureRect


func _ready():
	
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass
	
	# weapon = weapons[weapon_index] # Weapon must never be nil
	# initiate_change_weapon(weapon_index)

func _physics_process(delta):
	
	# Handle functions
	
	handle_controls(delta)
	handle_gravity(delta)
	
	# Movement

	var applied_velocity: Vector3
	
	movement_velocity = transform.basis * movement_velocity # Move forward
	
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	move_and_slide()
	
	# Rotation
	
	camera.rotation.z = lerp_angle(camera.rotation.z, -input_mouse.x * 25 * delta, delta * 5)	
	
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
	
	# container.position = lerp(container.position, container_offset - (basis.inverse() * applied_velocity / 30), delta * 10)
	
	#Movement sound
	
	# if is_on_floor():
	# 	if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			# $Audio_Walk.play()
	
	# Landing after jump or falling
	
	camera.position.y = lerp(camera.position.y, 0.0, delta * 5)
	
	if is_on_floor() and gravity > 1 and !previously_floored: # Landed
		# Audio.play("sounds/land.ogg")
		camera.position.y = -0.1
	
	previously_floored = is_on_floor()

	# if raycast.is_colliding():
	# 	# check if object is a unit
	# 	var obj = raycast.get_collider()
	# 	if obj.is_in_group("unit"):
	# 		# obj is Unit
	# 		print("is this happening")
	# 		obj.unit_clicked.emit()
	
	# Falling/respawning
	
	if position.y < -10:
		get_tree().reload_current_scene()

# Mouse movement

func _input(event):
	if event is InputEventMouseMotion and mouse_captured:
		
		input_mouse = event.relative / mouse_sensitivity
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity

func handle_controls(_delta):
	
	# # Mouse capture
	
	# if Input.is_action_just_pressed("mouse_capture"):
	# 	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# 	mouse_captured = true
	
	# if Input.is_action_just_pressed("mouse_capture_exit"):
	# 	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# 	mouse_captured = false
		
	# 	input_mouse = Vector2.ZERO
	
	# Run speed movemen
	speed_increase = run_speed_amplifier if Input.is_action_pressed("run") else 1.0
	
	
	# Movement
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	movement_velocity = Vector3(input.x, 0, input.y).normalized() * (movement_speed * speed_increase)
	
	# Rotation
	
	var rotation_input := Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	
	rotation_target -= Vector3(-rotation_input.y, -rotation_input.x, 0).limit_length(1.0) * gamepad_sensitivity
	rotation_target.x = clamp(rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
	
	# Jumping
	
	if Input.is_action_just_pressed("jump"):
		# if jump_single or jump_double:
			# Audio.play("sounds/jump_a.ogg, sounds/jump_b.ogg, sounds/jump_c.ogg")
		if jump_double:
			
			gravity = -jump_strength
			jump_double = false
			
		if(jump_single): action_jump()
		# $Audio_Jump.play()
		
	# Weapon switching
	
	# action_weapon_toggle()

# Handle gravity

func handle_gravity(delta):
	
	gravity += 20 * delta
	
	if gravity > 0 and is_on_floor():
		
		jump_single = true
		gravity = 0

# Jumping

func action_jump():
	
	gravity = -jump_strength
	
	jump_single = false;
	jump_double = true;

func damage(amount):
	
	health -= amount
	health_updated.emit(health) # Update health on HUD
	
	if health < 0:
		get_tree().reload_current_scene() # Reset when out of health
