extends EnemyState


func physics_update(_delta: float) -> void:
	if enemy.can_attack and not enemy.is_diving:
		enemy.is_attacking = true
		enemy.can_attack = false
		enemy.attack_cooldown.start()

		var knockback_scale = clamp(1 - (enemy.global_position.y - enemy.min_height) / (enemy.max_height - enemy.min_height), 0, 1)
		var knockback = enemy.attack_knockback * knockback_scale

		if enemy.animation_player.current_animation == "RunRight":
			enemy.velocity.y -= knockback.y
		else:
			enemy.velocity.x += knockback.x

		enemy.velocity.y -= knockback.y

		var projectile: SonicBeam = enemy.projectile.instantiate()
		projectile.speed = enemy.projectile_speed
		projectile.target = enemy.player
		projectile.spawn_point = enemy.projectile_spawn_point
		projectile.emitter = enemy
		projectile.damage = enemy.projectile_damage
		projectile.despawn_distance = enemy.projectile_despawn_distance
		enemy.projectiles_container.add_child(projectile)

		state_machine.transition_to("Surround")

		enemy.move_and_slide()
