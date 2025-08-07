extends Node

@onready var level_text: RichTextLabel = $Score/VBoxContainer/LevelText
@onready var score_text: RichTextLabel = $Score/VBoxContainer/ScoreText



func _on_exit_button_pressed() -> void:
	AudioManager.play_click()
	Shared.reset_game_vars()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
func _process(delta):
	level_text.text = str(Shared.level)
	score_text.text = str(Shared.currentscore)
