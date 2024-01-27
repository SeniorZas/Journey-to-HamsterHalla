extends Control

@onready var main = $"../"
func _on_resumir_pressed():
	get_tree().paused = false
	main.pauseMenu()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_exit_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_exit_to_desktop_pressed():
	get_tree().quit()
