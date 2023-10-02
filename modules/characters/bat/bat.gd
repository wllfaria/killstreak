extends "res://components/enemy.gd"

@export var dive_range_radius := 60.0
@export var dive_duration: float = 1.0
@export var dive_distance: float = 100.0
@export var dive_height: float = 50.0
@export var dive_cooldown_delay: float = 7.0
@export var projectile: PackedScene

var can_dive: bool = true
var is_diving: bool = false
var is_in_grace_period = false

@onready var dive_range: AttackRange = $DiveRange
@onready var dive_cooldown: Timer = $Timers/DiveCooldown

func _ready():
	global_settings.sound_effects_volume_changed.connect(_change_sfx_volume)
	die_sfx.volume_db = global_settings.sound_effects_volume
	hit_sfx.volume_db = global_settings.sound_effects_volume
	hurt_duration.wait_time = hurt_duration_delay
	attack_range.set_radius(attack_range_radius)
	attack_cooldown.wait_time = attack_cooldown_delay
	dive_range.set_radius(dive_range_radius)
	dive_cooldown.wait_time = dive_cooldown_delay


func is_on_dive_range():
	var bodies := dive_range.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			return true
	return false


func _on_dive_cooldown_timeout():
	can_dive = true
	is_diving = false


func _on_health_component_died() -> void:
	animation_player.play("Die")
	die_sfx.play()
	animation_player.connect("animation_finished", _delete_self)


func _delete_self(animation_name: String) -> void:
	if animation_name == "Die":
		queue_free()


func _change_sfx_volume(volume: float):
	hit_sfx.volume_db = volume
	die_sfx.volume_db = volume
