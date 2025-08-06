extends Node


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

var mastervol = 1.5
var sfxvol = 1.5
var musicvol = 1.5
