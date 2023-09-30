extends PlayerState

var _last_direction = 0
var _acceleration_to_use


func enter(_msg := {}):
	_last_direction = 0
	_acceleration_to_use = player.acceleration


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if (direction != _last_direction):
			_acceleration_to_use = player.turn_acceleration
			_last_direction = direction
		else:
			_acceleration_to_use = player.acceleration
		player.velocity.x = move_toward(player.velocity.x, direction * player.run_speed, _acceleration_to_use)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.friction)

	player.velocity.y += player.gravity * delta

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif is_equal_approx(direction, 0.0):
		state_machine.transition_to("Idle")

	player.move_and_slide()
