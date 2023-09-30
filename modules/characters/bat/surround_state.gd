extends EnemyState

var _target: Vector2
var _random = RandomNumberGenerator.new()

func enter(_msg := {}) -> void:
	_random.randomize()


func physics_update(delta: float) -> void:
	_target = _get_circle_position(_random.randf())
	var direction = (_target - enemy.global_position).normalized()
	var desired_velocity = direction * enemy.run_speed
	var steering = (desired_velocity - enemy.velocity) * delta * 2.5
	enemy.velocity += steering

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

