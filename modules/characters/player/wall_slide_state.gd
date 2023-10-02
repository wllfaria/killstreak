extends PlayerState

var _wall_slide_time := 0.0


func enter(_msg := {}) -> void:
	_wall_slide_time = 0


func physics_update(delta: float) -> void:
	if _is_disabled:
		return
	_wall_slide_time += delta

	var direction = Input.get_axis("move_left", "move_right")
	if player.is_on_wall() and direction and _wall_slide_time < player.wall_slide_max_time and not player.wall_slide_exhausted():
		player.velocity.y = player.wall_slide_gravity
	else:
		player.wall_slide_cooldown.start()
		state_machine.transition_to("Fall")

	if player.is_on_floor():
		player.jump_amount = 0
		player.last_time_on_ground = 0
		player.wall_slide_cooldown.stop()
		if not direction:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")

	if Input.is_action_just_pressed("jump") and not player.wall_slide_exhausted():
		state_machine.transition_to("Jump")

	player.move_and_slide()
