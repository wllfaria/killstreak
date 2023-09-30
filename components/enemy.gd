class_name Enemy
extends "res://components/character.gd"

@export var health: float = 10.0
@export var health_component: HealthComponent
@export var hurt_duration_delay: float = 0.15
@export var rotation_speed: float = 2.0
@export var should_face_player: bool = false
@export var surround_radius := 40.0
@export var run_speed := 100.0
@export var attack_range_radius := 200.0
@export var attack_cooldown_delay: float = 3.0

var can_attack: bool = true
var is_attacking: bool = false

@export var player: Player

@onready var sprite = $Sprite
@onready var attack_range: AttackRange = $AttackRange
@onready var attack_cooldown: Timer = $Timers/AttackCooldown


func _ready():
	hurt_duration.wait_time = hurt_duration_delay
	attack_range.set_radius(attack_range_radius)
	attack_cooldown.wait_time = attack_cooldown_delay


func _physics_process(delta):
	if should_face_player:
		_face_player(delta)


func is_on_attack_range():
	var bodies := attack_range.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			return true
	return false


func _on_health_component_died() -> void:
	animation_player.play("Die")
	await animation_player.animation_finished
	queue_free()


func _face_player(delta: float):
	var direction = player.global_position - global_position
	var angle = sprite.transform.x.angle_to(direction)
	sprite.rotate(sign(angle) * min(delta * rotation_speed, abs(angle)))


func _on_attack_cooldown_timeout():
	can_attack = true
