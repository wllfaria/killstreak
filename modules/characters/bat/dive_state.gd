extends EnemyState

var _dive_progress: float = 0.0


func physics_update(delta: float) -> void:
	enemy.can_dive = false
	if enemy.can_dive and not enemy.is_attacking:
		var direction = (enemy.player.global_position - enemy.global_position).normalized()
		var target_position = enemy.player.global_position  + direction * enemy.dive_distance
		var curve = _get_dive_curve(enemy.global_position, target_position, enemy.dive_height)

		_dive_progress += delta / enemy.dive_duration
		if _dive_progress > 1.0:
			_dive_progress = 1.0

		enemy.global_position = curve.sample_baked(_dive_progress)
		enemy.move_and_slide()


func _get_dive_curve(start: Vector2, end: Vector2, height: float) -> Curve2D:
	var curve = Curve2D.new()
	curve.add_point(start, Vector2.ZERO, Vector2.ZERO)

	var mid_point = (start + end) / 2.0
	mid_point.y -= height

	curve.add_point(mid_point, Vector2.ZERO, Vector2.ZERO)
	curve.add_point(end, Vector2.ZERO, Vector2.ZERO)

	curve.sample_baked(64)
	return curve
