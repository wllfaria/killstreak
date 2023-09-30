extends EnemyState


func physics_update(delta: float) -> void:
	if enemy.can_attack and not enemy.is_diving:
		enemy.is_attacking = true
		enemy.can_attack = false
		enemy.attack_cooldown.start()

		var projectile: SonicBeam = enemy.projectile.instance()
