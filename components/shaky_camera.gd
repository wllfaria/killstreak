class_name ShakyCamera
extends Camera2D

@export var noise_shake_strength := 60.0
@export var noise_shake_speed := 30.0
@export var shake_decay_rate := 3.0

var _noise_i := 0.0
var _shake_strength := 0.0

@onready var noise := FastNoiseLite.new()
@onready var rand := RandomNumberGenerator.new()


func _process(delta: float) -> void:
	_shake_strength = lerp(_shake_strength, 0.0, shake_decay_rate * delta)
	offset = _get_noise_offset(delta, noise_shake_speed, _shake_strength)


func apply__shake() -> void:
	_shake_strength = noise_shake_strength


func apply_smoothened_shake(smoothing_multiplier: float) -> void:
	_shake_strength = noise_shake_strength * smoothing_multiplier


func _get_noise_offset(delta: float, speed: float, strength: float) -> Vector2:
	_noise_i += delta * speed
	return Vector2(
		noise.get_noise_2d(1, _noise_i) * strength,
		noise.get_noise_2d(100, _noise_i) * strength
	)
