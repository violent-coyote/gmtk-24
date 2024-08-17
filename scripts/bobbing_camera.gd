extends Camera3D

@export var tween_duration : float = 1.0
@export var bob_amplitude : float = 0.05
@export var bob_frequency : float = 2.0

var original_position : Vector3
var bob_timer : float = 0.0

func _ready():
	original_position = position

func _process(delta):
	bob_timer += delta
	position.y = original_position.y + sin(bob_timer * bob_frequency) * bob_amplitude