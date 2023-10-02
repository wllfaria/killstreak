extends PlayerState

signal shoot()
var _last_state: String


func enter(msg := {}):
	if msg.has("last_state"):
		_last_state = msg.get("last_state")
	else:
		_last_state = "Idle"

func physics_update(_delta: float) -> void:
	if _is_disabled:
		return
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		if direction < 0:
			player.animation_player.play("RunLeft")
		else:
			player.animation_player.play("RunRight")
		player.velocity.x = move_toward(player.velocity.x, direction * player.shooting_run_speed, player.shooting_acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.friction)

	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")

	if not Input.is_action_pressed("shoot"):
		state_machine.transition_to(_last_state)

	if not player.target:
		if direction:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to(_last_state)
		return

	if not player.can_shoot:
		return

	player.can_shoot = false
	player.shoot_cooldown.start()
	emit_signal("shoot")
	player.shoot_sfx.pitch_scale = randf_range(0.8, 1.5)
	player.shoot_sfx.play()

	var projectile: KnightLaser = player.shoot_projectile.instantiate()
	projectile.speed = player.shoot_projectile_speed
	projectile.target = player.target
	projectile.spawn_point = player.projectile_spawn_point
	projectile.emitter = player
	projectile.damage = player.primary_attack_damage
	player.projectiles_container.add_child(projectile)
