extends Control

@onready var main = $"../"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _on_respawn_button_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")



func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
