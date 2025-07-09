extends Node

var current_tetromino 
@onready var board: Node = $"../Board" as Board


func _ready():
	current_tetromino = Shared.Tetromino.values().pick_random()
	board.spawn_tetromino(current_tetromino, false, null)
