extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://world3.tscn")


func _on_exit_pressed():
	get_tree().quit()
