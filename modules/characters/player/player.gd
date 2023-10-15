class_name Player
extends "res://components/character.gd"

signal shoot()
signal died()

@export var run_speed := 100.0
@export var shooting_run_speed := 50.0
@export var acceleration := 10.0
@export var turn_acceleration := 20.0
@export var hurt_duration_delay: float = 0.15
@export var jump_acceleration := 5.0
@export var fall_acceleration := 3.0
@export var shooting_acceleration := 60.0
@export var friction := 50.0
@export var jump_friction := 50.0
@export var fall_friction := 50.0
@export var jump_force := 400.0
@export var double_jump_force := 300.0
@export var wall_jump_force := Vector2(300.0, -300.0)
@export var wall_slide_gravity := 200.0
@export var wall_slide_max_time := 0.5
@export var jump_buffer_delay := 0.1
@export var coyote_jump_delay := 0.15
@export var push_off_ledge_delay := 0.1
@export var base_fall_gravity_multiplier := 1.0
@export var max_fall_gravity_multiplier := 2.5
@export var jump_cut_magnitude := 0.5
@export var dash_duration := 0.2
@export var dash_cooldown := 0.4
@export var dash_speed := 300.0
@export var vertical_dash_speed := 100.0
@export var max_jumps := 2
@export var shoot_delay := .3
@export var shoot_projectile: PackedScene
@export var shoot_projectile_speed := 100.0
@export var projectiles_container: Node
@export var attack_range_radius := 140.0
@export var primary_attack_damage := 10
@export var health := 100
@export var health_component: HealthComponent
@export var grace_period_time: float = 1.5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_time_on_ground := 0.0
var facing_direction := Vector2.RIGHT
var can_dash := true
var can_shoot := true
var jump_amount := 0
var target: CharacterBody2D
var is_in_grace_period: bool = false

@onready var outer_left_raycast: RayCast2D  = $OuterLeft
@onready var inner_left_raycast: RayCast2D = $InnerLeft
@onready var outer_right_raycast: RayCast2D  = $OuterRight
@onready var inner_right_raycast: RayCast2D = $InnerRight
@onready var wall_slide_cooldown: Timer = $Timers/WallSlideCooldown
@onready var shoot_cooldown: Timer = $Timers/ShootCooldown
@onready var projectile_spawn_point: Marker2D = $ProjectileSpawn
@onready var attack_range: AttackRange = $AttackRange
@onready var grace_period_timer: Timer = $Timers/GracePeriod
@onready var shoot_sfx: AudioStreamPlayer = $Sounds/Shoot
@onready var jump_sfx: AudioStreamPlayer = $Sounds/Jump


func _ready():
	hit_sfx.volume_db = global_settings.sound_effects_volume
	die_sfx.volume_db = global_settings.sound_effects_volume
	shoot_sfx.volume_db = global_settings.sound_effects_volume
	hurt_duration.wait_time = hurt_duration_delay
	health_component.max_health = health
	shoot_cooldown.wait_time = shoot_delay
	attack_range.set_radius(attack_range_radius)
	grace_period_timer.wait_time = grace_period_time
	global_settings.sound_effects_volume_changed.connect(_set_sound_effects_volume)


func _input(_event):
	if not ($StateMachine/Dash as Dash).is_dashing():
		var dash_direction := Input.get_vector("move_left" , "move_right", "move_up", "move_down")
		facing_direction = dash_direction


func _physics_process(_delta):
	move_and_slide()


func disable_controls():
	$StateMachine/Dash.set_disabled(true)
	$StateMachine/Firing.set_disabled(true)
	$StateMachine/WallSlide.set_disabled(true)
	$StateMachine/Jump.set_disabled(true)
	$StateMachine/Run.set_disabled(true)
	$StateMachine/Idle.set_disabled(true)
	$StateMachine/Fall.set_disabled(true)


func is_falling() -> bool:
	return velocity.y > 0.0


func wall_slide_exhausted() -> bool:
	return !wall_slide_cooldown.is_stopped()


func _on_shoot_cooldown_timeout():
	can_shoot = true


func _on_health_component_health_changed(health_update: HealthComponent.HealthUpdate):
	if not health_update.is_heal:
		is_in_grace_period = true
		grace_period_timer.start()


func _on_health_component_died():
	emit_signal("died")


func _on_grace_period_timeout():
	is_in_grace_period = false


func _on_firing_shoot():
	emit_signal("shoot")


func _on_spawn_enemies_enemy_died():
	health_component.heal(6)


func _set_sound_effects_volume(volume: float):
	shoot_sfx.volume_db = volume
	die_sfx.volume_db = volume
	hit_sfx.volume_db = volume
