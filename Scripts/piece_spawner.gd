extends Node

var current_tetromino 
@onready var board: Node = $"../Board" as Board

#Spawns tetrominos infinitely.
func _ready():
	current_tetromino = Shared.Tetromino.values().pick_random()
	board.spawn_tetromino(current_tetromino, false, null)
	board.tetromino_locked.connect(on_tetromino_locked)
	
#Spawns new teromino infinitely after tetromino locks.
func on_tetromino_locked():
	var new_tetromino = Shared.Tetromino.values().pick_random()
	board.spawn_tetromino(new_tetromino, false, null)
