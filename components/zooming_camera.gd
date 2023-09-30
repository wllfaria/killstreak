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
	zoom += Vector2(delta, delta) * zoom_speed * zoom_factor
	zoom = clamp(zoom, min_zoom, max_zoom)

	zoom_progress += delta / zoom_duration
	if zoom_progress > 1.0:
		zoom_progress = 1.0

	if zoom_progress >= .3:
		limit_bottom = lerp(limit_bottom, 187, 1.0)
	if zoom_progress >= .6:
		limit_bottom = lerp(limit_bottom, 184, 1.0)
	if zoom_progress >= 1:
		limit_bottom = lerp(limit_bottom, 182, 1.0)



func _ease_in_out_sine(x: float) -> float:
	return -(cos(PI * x) - 1) / 2
