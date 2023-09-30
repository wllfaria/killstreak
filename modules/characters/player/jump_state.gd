extends PlayerState


func enter(msg := {}) -> void:
	player.can_dash = true
	if msg.has("do_double_jump"):
		do_double_jump()
	else:
		do_jump()


func physics_update(delta: float) -> void:
	player.last_time_on_ground += delta

	if not player.is_on_floor() and player.velocity.y > 0:
		state_machine.transition_to("Fall")

	if Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")

	if Input.is_action_just_released("jump") and not player.is_on_wall():
		player.velocity.y *= player.jump_cut_magnitude

	if Input.is_action_just_pressed("jump") \
			and player.jump_amount < player.max_jumps \
			and player.jump_amount > 0 \
			and player.last_time_on_ground > 0.02:
		do_double_jump()

	if player.outer_right_raycast.is_colliding() \
			and not player.inner_right_raycast.is_colliding() \
			and not player.inner_left_raycast.is_colliding() \
			and not player.outer_left_raycast.is_colliding():
		player.global_position.x -= 5
	elif player.outer_left_raycast.is_colliding() \
			and not player.inner_left_raycast.is_colliding() \
			and not player.inner_right_raycast.is_colliding() \
			and not player.outer_right_raycast.is_colliding():
		player.global_position.x += 5

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		player.velocity.x = move_toward(player.velocity.x, direction * player.run_speed, player.jump_acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.jump_friction)

	player.velocity.y += player.gravity * delta
	player.move_and_slide()


func do_jump() -> void:
	if player.is_on_wall() and Input.is_action_pressed("move_right") and not player.is_on_floor():
		player.velocity.x = -player.wall_jump_force.x
		player.velocity.y = player.wall_jump_force.y
	elif player.is_on_wall() and Input.is_action_pressed("move_left") and not player.is_on_floor():
		player.velocity.x = player.wall_jump_force.x
		player.velocity.y = player.wall_jump_force.y
	elif player.last_time_on_ground < 0.01:
		player.jump_amount += 1
		player.velocity.y -= player.jump_force


func do_double_jump() -> void:
	if player.is_on_wall() and Input.is_action_pressed("move_right") and not player.is_on_floor():
		player.velocity.x = -player.wall_jump_force.x
		player.velocity.y = player.wall_jump_force.y
	elif player.is_on_wall() and Input.is_action_pressed("move_left") and not player.is_on_floor():
		player.velocity.x = player.wall_jump_force.x
		player.velocity.y = player.wall_jump_force.y
	else:
		player.jump_amount += 1
		player.velocity.y -= player.double_jump_force
