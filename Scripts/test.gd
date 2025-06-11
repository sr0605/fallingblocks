extends CharacterBody2D



const SHIFT = 64
var cooldown = 0
var allow_input = 0
func _physics_process(delta: float) -> void:

	# Uses cooldown mechanism in tandem with the delta already used for the physics
	# proccess to only allow a ceratin amount of inputs/second.
	# Can adjust cooldown (from here or elsewhere) to determine how fast pieces
	# move on the fly.
	cooldown -= delta
	if cooldown <= 0:
		allow_input = 1
		cooldown = .1

	
	var hor_direction := Input.get_axis("ui_left", "ui_right")
	if allow_input:
		if hor_direction:
			position.x += hor_direction * SHIFT
	 	#Eventually need to make 'ui_up' do slam instead of pushing pieces upward.
		var vert_direction := Input.get_axis("ui_up", "ui_down")
		if vert_direction:
			position.y += vert_direction * SHIFT
	
	allow_input = 0
