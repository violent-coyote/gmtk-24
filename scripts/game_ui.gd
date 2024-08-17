extends Control
class_name GameUI

@onready var pause_menu_controller : Node = $PauseMenuController
@onready var background_music_player :AudioStreamPlayer = $BackgroundMusicPlayer
@onready var loading_screen : CanvasLayer = $LoadingScreen
@onready var input_display_label : Label = $InputDisplayLabel

# Container with Buttons
@onready var container : Control = $Container
@onready var add_button : Button = $Container/AddButton
@onready var vbox_container :VBoxContainer = $Container/VBoxContainer

# labels 1-5
@onready var label : Label = $Container/VBoxContainer/PanelContainer/Label
@onready var label2: Label  = $Container/VBoxContainer/PanelContainer2/Label
@onready var label3: Label  = $Container/VBoxContainer/PanelContainer3/Label
@onready var label4: Label  = $Container/VBoxContainer/PanelContainer4/Label
@onready var label5: Label  = $Container/VBoxContainer/PanelContainer5/Label

# bottom row buttons 1 - 8
@onready var button: Button  = $Container/HBoxContainer/Button
@onready var button2: Button  = $Container/HBoxContainer/Button2
@onready var button3: Button  = $Container/HBoxContainer/Button3
@onready var button4: Button  = $Container/HBoxContainer/Button4
@onready var button5: Button  = $Container/HBoxContainer/Button5
@onready var button6: Button  = $Container/HBoxContainer/Button6
@onready var button7: Button  = $Container/HBoxContainer/Button7
@onready var button8: Button  = $Container/HBoxContainer/Button8

func update_all_labels(str : String):
	label.text = str
	label2.text = str
	label3.text = str
	label4.text = str
	label5.text = str
	
# @export var win_scene : PackedScene
# @export var lose_scene : PackedScene
# func _ready():
# 	InGameMenuController.scene_tree = get_tree()

# func _on_level_lost():
# 	InGameMenuController.open_menu(lose_scene, get_viewport())

# func _on_level_won():
# 	$LevelLoader.advance_and_load_level()

# func _on_level_loader_level_loaded():
# 	await $LevelLoader.current_level.ready
# 	if $LevelLoader.current_level.has_signal("level_won"):
# 		$LevelLoader.current_level.level_won.connect(_on_level_won)
# 	if $LevelLoader.current_level.has_signal("level_lost"):
# 		$LevelLoader.current_level.level_lost.connect(_on_level_lost)
# 	$LoadingScreen.close()

# func _on_level_loader_levels_finished():
# 	InGameMenuController.open_menu(win_scene, get_viewport())

# func _on_level_loader_level_load_started():
# 	$LoadingScreen.reset()

