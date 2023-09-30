extends PlayerState

signal target_switched(enemy: Enemy)
var enemies: Dictionary = {}


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("change_target"):
		_change_target()


func _process(_delta: float) -> void:
	var bodies := player.attack_range.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			var registered_enemy := _enemy_already_registered(body)
			if not registered_enemy.get("enemy"):
				body.health_component.connect("died", func(): _on_enemy_died(body))
				enemies[body] = { enemy = body, visited = false  }

	if not player.target:
		_change_target()


func _change_target():
	for body in player.attack_range.get_overlapping_bodies():
		if not body.is_in_group("Enemy"):
			continue
		if not player.target:
			enemies[body].visited = true
			player.target = body
			break
		if player.target == body:
			continue
		player.target = body


func _enemy_already_registered(body: Enemy) -> Dictionary:
	if enemies.has(body):
		return enemies[body]
	return {}


func _on_enemy_died(body: Enemy) -> void:
	enemies.erase(body)
