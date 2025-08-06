extends Node

#
# Creates a instance of an audiostream player tied to no root node, just in script, plays the click sound, then deletes itself

func play_click() -> void:
	var instance = AudioStreamPlayer.new()
	instance.stream = load("res://Assets/Sounds/Menu_Sound.wav")
	instance.volume_db = -10
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()

func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()
