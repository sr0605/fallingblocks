extends Node2D


class_name Tetromino

signal lock_tetromino(tetromino: Tetromino)

var rotation_index = 0
var wall_kicks
var tetromino_data
var is_next_piece
var pieces = []
var other_tetrominos: Array[Tetromino] = []

#Defines bound coordinates for the pieces. Calculations are the inner borders of the grid (320 * 640) With an extra 8 pixels added to do the proper collision check.
var bounds = {
	"min_x": -328,
	"max_x": 328,
	"max_y": 648 
}


@onready var timer: Timer = $Timer
@onready var piece_scene = preload("res://Scenes/piece.tscn")

var tetromino_cells


func _ready():
	tetromino_cells = Shared.cells[tetromino_data.tetromino_type]
	
	for cell in tetromino_cells:
		var piece = piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(tetromino_data.piece_texture)
		piece.position = cell * piece.get_size()
		
		#Checks type of tetromino and what wall kicks should be used for the piece.
		if is_next_piece == false:
			position = tetromino_data.spawn_position
			wall_kicks = Shared.wall_kicks_i if tetromino_data.tetromino_type == Shared.Tetromino.I else Shared.wall_kicks_jlostz

func _input(event):
	if Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("hard_drop"):
		hard_drop()
	elif Input.is_action_just_pressed("rotate_left"):
		rotate_tetromino(-1)
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_tetromino(1)

func move(direction: Vector2) -> bool:
	var new_position = calculate_global_position(direction, global_position)
	#print(new_position)
	if new_position:
		global_position = new_position
		return true
	return false

func calculate_global_position(direction: Vector2, starting_global_position: Vector2):
	#TODO: check for collision with other tetrominos
	if is_colliding_with_other_tetrominos(direction, starting_global_position):
		return null
	#TODO: Check for collision with game bounds (complete).
	if !is_within_game_bounds(direction, starting_global_position):
		return null
	return starting_global_position + direction * pieces[0].get_size().x

func is_within_game_bounds(direction: Vector2, starting_global_position: Vector2):
	
	for piece in pieces:
		var new_position = piece.position + starting_global_position + direction * piece.get_size()
		if new_position.x < bounds.get("min_x") || new_position.x > bounds.get("max_x") || new_position.y >= bounds.get("max_y"):
			return false
	return true

func is_colliding_with_other_tetrominos(direction: Vector2, starting_global_position: Vector2):
	#Iterates loop of all the tetrominos and all of ther respective pieces.
	for tetromino in other_tetrominos:
		var tetromino_pieces = tetromino.get_children().filter(func (c): return c is Piece)
		for tetromino_piece in tetromino_pieces: 
			for piece in pieces:
				if starting_global_position + piece.position + direction * piece.get_size().x == tetromino.global_position + tetromino_piece.position:
					return true
	return false
	
func rotate_tetromino(direction: int):
	var original_rotation_index = rotation_index
	if tetromino_data.tetromino_type == Shared.Tetromino.O:
		return
		
	apply_rotation(direction)
	
	rotation_index = wrap(rotation_index + direction, 0, 4)
	
	if !test_walls_kicks(rotation_index, direction):
		rotation_index = original_rotation_index
		apply_rotation(-direction)

func test_walls_kicks(rotation_index: int, rotation_direction: int):
	var wall_kicks_index = get_wall_kick_index(rotation_index, rotation_direction)
	
	for i in wall_kicks[0].size():
		var translation = wall_kicks[wall_kicks_index][i]
		if move(translation):
			return true
	return false

func get_wall_kick_index(rotation_index: int, rotation_direction):
	var wall_kick_index = rotation_index * 2
	if rotation_direction < 0:
		wall_kick_index -= 1
	return wrap(wall_kick_index, 0, wall_kicks.size())

func apply_rotation(direction: int):
	var rotation_matrix = Shared.clockwise_rotation_matrix if direction == 1 else Shared.counter_clockwise_rotation_matrix
	
	var tetromino_cells = Shared.cells[tetromino_data.tetromino_type]
	
	for i in tetromino_cells.size():
		var cell = tetromino_cells[i]
		var x
		var y
		var cooridinates = rotation_matrix[0] * cell.x + rotation_matrix[1] * cell.y
		tetromino_cells[i] = cooridinates
	
	for i in pieces.size():
		var piece = pieces[i]
		piece.position = tetromino_cells[i] * piece.get_size()

func hard_drop():
	while(move(Vector2.DOWN)):
		continue
	lock()

func lock():
	timer.stop()
	lock_tetromino.emit(self)
	#Does not accept input from user any longer.
	set_process_input(false)

func _on_timer_timeout() -> void:
	var should_lock = !move(Vector2.DOWN)
	if should_lock:
		lock()
	
