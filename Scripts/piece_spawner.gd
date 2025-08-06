extends Node

var current_tetromino 
@onready var board: Node = $"../Board" as Board
@onready var ui: CanvasLayer = $"../UI" as UI
var is_game_over = false

#Spawns tetrominos infinitely.
func _ready():
	current_tetromino = Shared.Tetromino.values().pick_random()
	board.spawn_tetromino(current_tetromino, false, null)
	board.tetromino_locked.connect(on_tetromino_locked)
	board.game_over.connect(on_game_over)
	
#Spawns new teromino infinitely after tetromino locks.
func on_tetromino_locked():
	if is_game_over:
		return
	var new_tetromino = Shared.Tetromino.values().pick_random()
	board.spawn_tetromino(new_tetromino, false, null)

func on_game_over():
	is_game_over = true
	ui.show_game_over()
