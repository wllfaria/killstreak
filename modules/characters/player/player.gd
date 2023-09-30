class_name Player
extends CharacterBody2D

@export var run_speed := 100.0
@export var acceleration := 10.0
@export var turn_acceleration := 20.0
@export var jump_acceleration := 5.0
@export var fall_acceleration := 3.0
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

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_time_on_ground := 0.0
var facing_direction := Vector2.RIGHT
var can_dash := false
var jump_amount := 0

@onready var outer_left_raycast: RayCast2D  = $OuterLeft
@onready var inner_left_raycast: RayCast2D = $InnerLeft
@onready var outer_right_raycast: RayCast2D  = $OuterRight
@onready var inner_right_raycast: RayCast2D = $InnerRight
@onready var wall_slide_cooldown: Timer = $WallSlideCooldown


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
