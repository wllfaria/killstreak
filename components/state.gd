class_name State
extends Node

var state_machine: StateMachine
var _is_disabled := false

func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if _is_disabled:
		return


func enter(_msg := {}) -> void:
	pass


func exit() -> void:
	pass


func set_disabled(value: bool) -> void:
	_is_disabled = value
