extends Control

func _ready() -> void:
	$MarginContainer/VBoxContainer/MasterSlider.value = Shared.mastervol
	$MarginContainer/VBoxContainer/SFXSlider.value = Shared.sfxvol
	$MarginContainer/VBoxContainer/MusicSlider.value = Shared.musicvol
	


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	Shared.mastervol = value
	
	
func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	Shared.sfxvol = value

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	Shared.musicvol = value

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	AudioManager.play_click()
