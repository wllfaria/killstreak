extends EnemyState

var _target: Vector2
var _random = RandomNumberGenerator.new()

func enter(_msg := {}) -> void:
	_random.randomize()
	enemy.is_attacking = false
	enemy.is_diving = false


func physics_update(delta: float) -> void:
	if not enemy.health_component.has_health_remaining.call():
		return
	_target = _get_circle_position(_random.randf())
	var direction = (_target - enemy.global_position).normalized()

	var player_direction = (enemy.player.global_position - enemy.global_position).normalized()
	if player_direction.x < 0:
			enemy.animation_player.play("RunLeft")
	else:
			enemy.animation_player.play("RunRight")

	var distance_to_player = enemy.global_position.distance_to(enemy.player.global_position)
	if distance_to_player < enemy.safe_radius and not enemy.can_dive:
		direction = (enemy.global_position - enemy.player.global_position).normalized()

	var desired_velocity = direction * enemy.run_speed
	var steering = (desired_velocity - enemy.velocity) * delta * 2.5
	enemy.velocity += steering


	if enemy.can_dive and not enemy.is_on_dive_range():
		_get_closer_circle_position(_random.randf())

	if enemy.can_dive and enemy.is_on_dive_range():
		state_machine.transition_to("Dive")
	elif enemy.can_attack and enemy.is_on_attack_range():
		state_machine.transition_to("Attack")

	enemy.move_and_slide()


func _get_circle_position(random: float) -> Vector2:
	var circle_center := enemy.player.global_position
	var radius := enemy.surround_radius
	var angle = random * PI * 2
	var x := circle_center.x + cos(angle) * radius
	var y := circle_center.y + sin(angle) * radius
	return Vector2(x, y)


func _get_closer_circle_position(random: float) -> Vector2:
	var circle_center := enemy.player.global_position
	var radius := enemy.surround_radius / 2
	var angle = random * PI * 2
	var x := circle_center.x + cos(angle) * radius
	var y := circle_center.y + sin(angle) * radius
	return Vector2(x, y)
