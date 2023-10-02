class_name ShrinkingWall
extends Control

signal player_smashed()
@export var shrinking_speed: float = 0.1
@export var is_left: bool
var _progress := 0.0
var _start_position := 0.0
var _killed_player := false
@onready var _offset = get_viewport().get_visible_rect().size.x / 2


func _ready():
	_start_position = get_child(0).position.x


func _process(delta: float) -> void:
	if _progress >= 1.0 and not _killed_player:
		emit_signal("player_smashed")
		_killed_player = true

	if _progress <= 1.5:
		for child in get_children():
			var child_position = child.position.x
			_progress = abs(child_position - _start_position) / _offset
			if is_left:
				if child.position.x > -10:
					child.position.x -= shrinking_speed * delta
			else:
				if child.position.x < 10:
					child.position.x += shrinking_speed * delta


func lose_progress() -> void:
	for child in get_children():
		if _progress > 0:
			if is_left:
				child.position.x += shrinking_speed * 2
			else:
				child.position.x -= shrinking_speed * 2
