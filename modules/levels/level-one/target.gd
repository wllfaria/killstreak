extends TextureRect

@export var player: Player
var _time := 0.0


func _process(delta: float) -> void:
	_time += delta
	if not player.target:
		self_modulate = Color(1, 1, 1, 0)
	else:
		self_modulate = Color(1, 1, 1, 1)
		position = player.target.get_global_transform_with_canvas().origin + Vector2(-8, -8)
		var scale_factor := 0.15 * (sin(_time * 5) + 1) + 0.3
		scale = Vector2(scale_factor, scale_factor)
		rotation += delta
