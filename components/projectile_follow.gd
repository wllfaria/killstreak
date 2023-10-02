class_name ProjectileFollow
extends Area2D

var spawn_point: Marker2D
var target: CharacterBody2D
var speed: float
var emitter: CharacterBody2D
var damage: float


var _last_target_position: Vector2


func _ready() -> void:
	global_position = spawn_point.global_position
	look_at(target.global_position)


func _physics_process(delta: float) -> void:
	var target_position
	if not is_instance_valid(target):
		queue_free()
		return
	else:
		_last_target_position = target.global_position
		target_position = target.global_position

	var distance = target_position.distance_to(global_position)
	var direction = (target_position - global_position).normalized()
	var velocity = direction * min(distance, speed * delta)
	global_position += velocity
	look_at(_last_target_position)
