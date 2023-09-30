extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.friction)

func update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Fall")

	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
