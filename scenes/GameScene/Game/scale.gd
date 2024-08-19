extends Node

@export var spine_node: NodePath
@export var bone_name: String = "any_bone_name"
@export var scale_factor: Vector2 = Vector2(2, 2)

func _ready():
	var spine = get_node(spine_node)
	
	if spine:
		var skeleton = spine.get_skeleton() 
		if skeleton:
			var bone = skeleton.find_bone(bone_name)
			if bone:
				bone.scale = scale_factor

				skeleton.update()
				print("Scaled bone: ", bone_name, " to ", scale_factor)
			else:
				print("Bone not found: ", bone_name)
		else:
			print("Skeleton not found.")
	else:
		print("Spine node not found.")
