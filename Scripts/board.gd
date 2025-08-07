extends Node

#Helps autocomplete by giving type to a script
class_name Board

signal tetromino_locked
signal game_over

const ROW_COUNT = 20
const COLUMN_COUNT = 10

#Calculates whether tetromino collides with other tetromino via array reference with this variable.
var tetrominos: Array[Tetromino] = []
#packedscene is so boardscene can be referenced within this scene
@export var tetromino_scene: PackedScene
#sound variables:
@onready var line_clear: AudioStreamPlayer = $LineClear



func spawn_tetromino(type: Shared.Tetromino, is_next_piece, spawn_position):
	var tetromino_data = Shared.data[type]
	var tetromino = tetromino_scene.instantiate() as Tetromino
	
	tetromino.tetromino_data = tetromino_data
	tetromino.is_next_piece = is_next_piece
	
	if is_next_piece == false:
		tetromino.position = tetromino_data.spawn_position
		tetromino.other_tetrominos = tetrominos
		#Listens for lock signal
		tetromino.lock_tetromino.connect(on_tetromino_locked)
		add_child(tetromino)

func on_tetromino_locked(tetromino: Tetromino):
	tetrominos.append(tetromino)
	#Emits signal that tetromino is locked
	tetromino_locked.emit()
	#TODO: check is game over
	check_game_over()
	#TODO check for the lines to clear
	clear_lines()

func check_game_over():
	for tetromino in tetrominos:
		var pieces = tetromino.get_children().filter(func (c): return c is Piece)
		for piece in pieces:
			var y_location = piece.global_position.y
			if y_location == -608:
				game_over.emit()
				print("Game Over")
				#Updates highscore if necessary then resets it
				if(Shared.currentscore > Shared.highscore):
					Shared.highscore = Shared.currentscore
				Shared.reset_game_vars()
			print(y_location)  

func clear_lines():
	var board_pieces = fill_board_pieces()
	clear_board_pieces(board_pieces)

func fill_board_pieces():
	var board_pieces = []
	
	for i in ROW_COUNT:
		board_pieces.append([])
		
	for tetromino in tetrominos:
		#This filters out the timer for the code to work.
		var tetromino_pieces = tetromino.get_children().filter(func (c): return c is Piece)
		for piece in tetromino_pieces:
			var row = (piece.global_position.y + piece.get_size().y / 2) / piece.get_size().y + ROW_COUNT / 2
			board_pieces[row - 1].append(piece)
	return board_pieces

func clear_board_pieces(board_pieces):
	var i = ROW_COUNT
	
	while i > 0:
		var row_to_analyze = board_pieces[i - 1]
		
		if row_to_analyze.size() == COLUMN_COUNT:
			clear_row(row_to_analyze)
			board_pieces[i - 1].clear()
			move_all_row_pieces_down(board_pieces, i)
		#Decremented to avoid endless loop.
		i -= 1
		

func clear_row(row):
	for piece in row:
		piece.queue_free()
	line_clear.play()
	Shared.linescleared += 1
	Shared.currentscore += 100 * Shared.scoremultiplier
	if(Shared.linescleared > 0 && (Shared.linescleared % 10 == 0)):
		Shared.level += 1
		Shared.timervalue *= 0.9
		Shared.scoremultiplier *= Shared.scoremultiplier #Squares to make scores go up like crazy after the first little while
		
	

func move_all_row_pieces_down(board_pieces, cleared_row_number):
	for i in range(cleared_row_number -1, 1, -1):
		var row_to_move = board_pieces[i - 1]
		#Checks if we hit an empty row. No need to check past one if we did.
		if row_to_move.size() == 0:
			return false
		for piece in row_to_move:
			piece.position.y += piece.get_size().y
			#board_pieces[cleared_row_number -1].append(piece)
		#board_pieces[i - 1].clear() (These lines caused only one full line to clear)
