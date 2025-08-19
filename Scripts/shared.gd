extends Node

const SAVEFILE = "user://savefile.save"

#Variables for music, values in linear, if used directly in some func use linear_to_db(value) first to change
var mastervol = 1.5
var sfxvol = 1.5
var musicvol = 1.5


#variables for scoring system
var highscore = 0
var currentscore: int = 0
var scoremultiplier = 1.1
var level = 1
var linescleared = 0
var timervalue = 1


#globally accessible func to reset so it changes properly no matter how you leave the game instance
func reset_game_vars() -> void:
	currentscore = 0
	level = 1
	linescleared = 0
	timervalue = 1
	scoremultiplier = 1.1
	
func save_score():
	if(Shared.currentscore > Shared.highscore):
		Shared.highscore = Shared.currentscore
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	file.store_32(Shared.highscore)
	
func load_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		Shared.highscore = file.get_32()

enum Tetromino {
	I, O, T, J, L, S, Z
}

#Constructs tetriminos along the x and y axis coords
var cells = {
	Tetromino.I: [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
	Tetromino.L: [Vector2(-1, 1), Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0)],
	Tetromino.J: [Vector2(1, 1), Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0)],
	Tetromino.O: [Vector2(0, 1), Vector2(1, 1), Vector2(0, 0), Vector2(1, 0)],
	Tetromino.Z: [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 0), Vector2(0, 0)],
	Tetromino.T: [Vector2(0, 1), Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0)],
	Tetromino.S: [Vector2(-1, 1), Vector2(0, 1), Vector2(0, 0), Vector2(1, 0)],
}

#Prevents rotations past walls by moving it away from wall
var wall_kicks_i = [
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-2), Vector2(-1,-2)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1,0), Vector2(2,1), Vector2(-1,-2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(2,0), Vector2(-1,2), Vector2(2,-1)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1,-2), Vector2(-2,1)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1,0), Vector2(2,1), Vector2(-1,-2)],
	[Vector2(0,0), Vector2(-2,0), Vector2(1,0), Vector2(-2,-1), Vector2(1,2)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1,-2), Vector2(-2,1)],
	[Vector2(0,0), Vector2(-1,0), Vector2(2,0), Vector2(-1,-2), Vector2(1,-2)]
]

var wall_kicks_jlostz = [
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1,-2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1,-1), Vector2(0,2), Vector2(1,2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1,-1), Vector2(0,2), Vector2(1,2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1,-2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,-2), Vector2(1,-2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,2), Vector2(-1,2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,2), Vector2(-1,2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,-2), Vector2(1,-2)]
]

# Dictionary that connects resources and logs as data
var data = {
	Tetromino.I: preload("res://Resources/i_piece_data.tres"),
	Tetromino.J: preload("res://Resources/j_piece_data.tres"),
	Tetromino.L: preload("res://Resources/l_piece_data.tres"),
	Tetromino.O: preload("res://Resources/o_piece_data.tres"),
	Tetromino.S: preload("res://Resources/s_piece_data.tres"),
	Tetromino.T: preload("res://Resources/t_piece_data.tres"),
	Tetromino.Z: preload("res://Resources/z_piece_data.tres")
}

#Uses reotation matrix in math (linear algebra) to rotate tetrominos - always rotating 90 degrees
var clockwise_rotation_matrix = [Vector2(0, -1), Vector2(1, 0)]
var counter_clockwise_rotation_matrix = [Vector2(0, 1), Vector2(-1, 0)]
