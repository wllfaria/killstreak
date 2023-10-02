extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.friction)
	player.animation_player.play("Idle")

func update(_delta: float) -> void:
	if _is_disabled:
		return
	if not player.is_on_floor():
		state_machine.transition_to("Fall")


	if Input.is_action_pressed("shoot"):
		state_machine.transition_to("Firing")
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
