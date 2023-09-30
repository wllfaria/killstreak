class_name AttackRange
extends Area2D


func set_radius(radius: float) -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.shape.radius = radius
