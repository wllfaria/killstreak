class_name Player
extends "res://components/character.gd"

@export var run_speed := 100.0
@export var shooting_run_speed := 50.0
@export var acceleration := 10.0
@export var turn_acceleration := 20.0
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

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_time_on_ground := 0.0
var facing_direction := Vector2.RIGHT
var can_dash := false
var can_shoot := true
var jump_amount := 0
var target: CharacterBody2D

@onready var outer_left_raycast: RayCast2D  = $OuterLeft
@onready var inner_left_raycast: RayCast2D = $InnerLeft
@onready var outer_right_raycast: RayCast2D  = $OuterRight
@onready var inner_right_raycast: RayCast2D = $InnerRight
@onready var wall_slide_cooldown: Timer = $Timers/WallSlideCooldown
@onready var shoot_cooldown: Timer = $Timers/ShootCooldown
@onready var projectile_spawn_point: Marker2D = $ProjectileSpawn
@onready var attack_range: AttackRange = $AttackRange


func _ready():
	health_component.max_health = health
	shoot_cooldown.wait_time = shoot_delay
	attack_range.set_radius(attack_range_radius)


func _input(_event):
	if not ($StateMachine/Dash as Dash).is_dashing():
		var dash_direction := Input.get_vector("move_left" , "move_right", "move_up", "move_down")
		facing_direction = dash_direction


func _physics_process(_delta):
	move_and_slide()


func is_falling() -> bool:
	return velocity.y > 0.0


func wall_slide_exhausted() -> bool:
	return !wall_slide_cooldown.is_stopped()


func _on_shoot_cooldown_timeout():
	can_shoot = true
