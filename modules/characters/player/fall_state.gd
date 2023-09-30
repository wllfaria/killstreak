extends PlayerState

var _jump_buffer_time: float = 0
var _fall_gravity_multiplier: float = 0


func enter(_msg := {}) -> void:
	_fall_gravity_multiplier = player.base_fall_gravity_multiplier


func update(delta: float) -> void:
	if Input.is_action_just_pressed('jump'):
		if player.last_time_on_ground < player.coyote_jump_delay:
			state_machine.transition_to("Jump")
		if not player.is_on_floor():
			_jump_buffer_time = player.jump_buffer_delay

	_jump_buffer_time -= delta


func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta * _fall_gravity_multiplier

	var fall_time: float = 0
	fall_time = player.velocity.y / player.gravity

	_fall_gravity_multiplier = clamp(
		lerp(player.base_fall_gravity_multiplier, player.max_fall_gravity_multiplier, fall_time),
		player.base_fall_gravity_multiplier,
		player.max_fall_gravity_multiplier
	)

	if Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
	else:
		state_machine.transition_to("Fall")

	if Input.is_action_just_pressed("jump") \
		and player.jump_amount < player.max_jumps \
		and player.jump_amount > 0 \
		and player.last_time_on_ground > 0.02:
		state_machine.transition_to("Jump", {do_double_jump = true})


	var direction = Input.get_axis("move_left", "move_right")


	if direction:
		if not player.is_on_floor() and player.is_on_wall():
			state_machine.transition_to("WallSlide")

		player.velocity.x = move_toward(player.velocity.x, direction * player.run_speed, player.fall_acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.fall_friction)

	if player.is_on_floor():
		player.last_time_on_ground = 0
		player.jump_amount = 0
		if _jump_buffer_time > 0:
			_jump_buffer_time = 0
			state_machine.transition_to("Jump")
		elif direction:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")

	player.move_and_slide()
