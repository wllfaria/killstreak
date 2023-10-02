class_name Dash
extends PlayerState

@export var dash_timer: Timer
@export var dash_cooldown: Timer

# TODO: verify why dash don't work with last direction when no direction is being currently pressed


func enter(_msg := {}) -> void:
	player.can_dash = false
	dash_timer.wait_time = player.dash_duration
	dash_cooldown.wait_time = player.dash_cooldown
	dash_timer.start()


func physics_update(_delta: float) -> void:
	if is_dashing():
		player.velocity.x = player.facing_direction.x * player.dash_speed
		if not player.is_on_floor():
			player.velocity.y = player.facing_direction.y * player.vertical_dash_speed

	player.move_and_slide()


func is_dashing():
	return !dash_timer.is_stopped()


func _on_dash_timer_timeout():
	player.velocity.x = 0
	state_machine.transition_to("Fall")
	dash_cooldown.start()


func _on_dash_cooldown_timeout():
	player.can_dash = true
