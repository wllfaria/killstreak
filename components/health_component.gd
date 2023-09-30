class_name HealthComponent
extends Node

signal health_changed(health_update: HealthUpdate)
signal died()
@export var max_health: float = 10.0: set = set_max_health

var current_health: float = 10.0: set = set_current_health
var has_health_remaining = func() -> bool: return !is_equal_approx(_current_health, 0.0)
var current_health_percent = func() -> float: return current_health / max_health if max_health > 0 else 0.0
var is_damaged = func() -> bool: return current_health < max_health
var _has_died: bool
var _current_health: float


func _ready():
	initialize_health()


func damage(amount: float) -> void:
	current_health -= amount


func heal(amount: float) -> void:
	damage(-amount)


func initialize_health() -> void:
	current_health = max_health
	_current_health = max_health


func set_max_health(value: float) -> void:
	max_health = value
	_current_health = max_health
	current_health = max_health
	if current_health > max_health:
		current_health = max_health
		_current_health = max_health


func set_current_health(value: float) -> void:
	var previous_health: float = _current_health
	_current_health = clamp(value, 0, max_health)
	var health_update = HealthUpdate.new(
		previous_health,
		_current_health,
		max_health,
		current_health_percent.call(),
		_current_health > previous_health
	)
	current_health = _current_health
	emit_signal("health_changed", health_update)
	if not has_health_remaining.call() and not _has_died:
		_has_died = true
		emit_signal("died")


class HealthUpdate:
	var previous_health: float
	var current_health: float
	var max_health: float
	var health_percent: float
	var is_heal: bool

	func _init(_previous_health: float, _current_health: float, _max_health: float, _health_percent: float, _is_heal: bool):
		self.previous_health = _previous_health
		self.current_health = _current_health
		self.max_health = _max_health
		self.health_percent = _health_percent
		self.is_heal = _is_heal
