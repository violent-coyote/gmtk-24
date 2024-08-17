extends SpineSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	get_animation_state().set_animation("happy",true,0)
	# get_animation_state().add_animation("sad",2,true,1)
