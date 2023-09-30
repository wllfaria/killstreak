class_name LinearProjectile
extends Area2D

var spawn_point: Marker2D
var target: CharacterBody2D
var speed: float
var emitter: CharacterBody2D
var damage: float
var despawn_distance: float

var _direction: Vector2


func _ready() -> void:
	global_position = spawn_point.global_position
	var target_position = target.global_position
	look_at(target.global_position)
	_direction = (target_position - global_position).normalized()


func _physics_process(delta: float) -> void:
	var velocity = _direction * speed * delta
	global_position += velocity
	look_at(global_position + velocity)

	if is_instance_valid(emitter) \
			and global_position.distance_to(spawn_point.global_position) > despawn_distance:
		queue_free()
