class_name ZoomingCamera
extends ShakyCamera

@export var zoom_speed := 0.6
@export var min_zoom := Vector2(1.0, 1.0)
@export var max_zoom := Vector2(4.0, 4.0)
@export var enable_zoom := true

var zoom_duration := 20.0
var zoom_progress := 0.0

func _process(delta: float) -> void:
	if not enable_zoom:
		return

	var zoom_factor = zoom_progress * _ease_in_out_sine(zoom_progress)
	zoom.x += Vector2(delta, delta).x * zoom_speed * zoom_factor
	zoom.x = clamp(zoom.x, min_zoom.x, max_zoom.x)

	zoom_progress += delta / zoom_duration
	if zoom_progress > 1.0:
		zoom_progress = 1.0


func _ease_in_out_sine(x: float) -> float:
	return -(cos(PI * x) - 1) / 2


func _on_enemy_died():
	if not enable_zoom:
		return
	var small_amount := 0.4
	zoom_progress -= zoom.x / max_zoom.x
	zoom.x -= small_amount


func _on_player_shoot():
	apply_smoothened_shake(0.3)
