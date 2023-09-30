class_name StateMachine
extends Node

signal transitioned(state_name: String)
@export var initial_state: NodePath
@onready var state: State = get_node(initial_state)


func _ready():
	await owner.ready
	for child in get_children():
		(child as State).state_machine = self
	state.enter()


func _unhandled_input(event):
	state.handle_input(event)


func _process(delta):
	state.update(delta)


func _physics_process(delta):
	state.physics_update(delta)


func transition_to(state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(state_name):
		return
	state.exit()
	state = get_node(state_name)
	state.enter(msg)
	emit_signal("transitioned", state_name)