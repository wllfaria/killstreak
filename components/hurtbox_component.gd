class_name HurtboxComponent
extends Area2D


@export var health_component: HealthComponent


func _physics_process(_delta):
	handle_bullet_collision()


func handle_bullet_collision():
	var areas := get_overlapping_areas()
	for area in areas:
		if area.is_in_group("Projectiles"):
			owner.play_hurt_animation()
			health_component.damage(area.damage)
			area.queue_free()
