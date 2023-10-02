extends Label


var _should_destroy := false
var inverted := false

func _ready() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	var y_offset := -16 if not inverted else 16
	tween.tween_property(self, "position:y", position.y + y_offset, .3)
	tween.tween_property(self, "scale", Vector2(0.6, 0.6), .3)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), .3)

	await tween.finished
	_should_destroy = true


func _process(_delta: float) -> void:
	if _should_destroy:
		queue_free()
