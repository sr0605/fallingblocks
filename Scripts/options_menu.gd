extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/MasterVolumeSlider.value = Autoload.vol_master
	$MarginContainer/VBoxContainer/SFXVolumeSlider.value = Autoload.vol_sfx
	$MarginContainer/VBoxContainer/MusicVolumeSlider.value = Autoload.vol_music
	

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	Autoload.vol_master = value
	
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	Autoload.vol_sfx = value

func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	Autoload.vol_music = value
