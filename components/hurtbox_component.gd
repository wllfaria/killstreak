class_name HurtboxComponent
extends Area2D


@export var health_component: HealthComponent


func _physics_process(_delta):
	_handle_projectile_collision()
	_handle_body_collision()


func _handle_projectile_collision():
	var areas := get_overlapping_areas()
	for area in areas:
		if area.is_in_group("Projectiles"):
			if area.emitter == owner:
				continue
			if is_instance_valid(area) and is_instance_valid(area.emitter) and is_instance_valid(owner):
				if area.emitter.is_in_group("Enemy") and owner.is_in_group("Enemy"):
					continue
				elif (area.emitter.is_in_group("Enemy") and owner.is_in_group("Player")) \
						or (area.emitter.is_in_group("Player") and owner.is_in_group("Enemy")):
					if owner.is_in_group("Player"):
						owner.is_in_grace_period = true
					owner.play_hurt_animation()
					owner.hit_sfx.play()
					health_component.damage(area.damage)
					area.queue_free()


func _handle_body_collision():
	var bodies := get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemy") \
				and owner.is_in_group("Player") \
				and not owner.is_in_grace_period:
			if owner.is_in_group("Player"):
				owner.is_in_grace_period = true
			owner.play_hurt_animation()
			health_component.damage((body as Enemy).projectile_damage)
