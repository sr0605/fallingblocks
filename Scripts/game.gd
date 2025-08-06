extends Node

func _on_exit_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
