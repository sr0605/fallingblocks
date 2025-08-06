extends Control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	AudioManager.play_click()

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
	AudioManager.play_click()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
