extends TextureProgressBar

@export var hurt_duration: Timer
var hurt_material: ShaderMaterial = preload("res://modules/assets/hurt_material.tres")


func _on_player_took_damage(_player: Player):
	value = value - 12
	hurt_duration.start()
	material = hurt_material


func _on_hit_duration_timeout():
	material = null


func _on_spawn_enemies_enemy_died():
	if value < 100:
		value += 6
