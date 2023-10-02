class_name SpawnEnemies
extends Node

signal enemy_died()
signal enemy_took_damage(enemy: Character)

@export var camera: Camera2D
@export var enemies_container: Node
@export var spawn_timer: Timer
@export var enemies: Array[PackedScene]
@export var player: Player
@export var projectiles_container: Node

var random = RandomNumberGenerator.new()


func _ready() -> void:
	random.randomize()


func _process(_delta: float) -> void:
	if not spawn_timer.is_stopped():
		return

	var camera_position = camera.global_position
	var viewport_size = get_viewport().get_visible_rect().size
	var random_spawn_x_coord = random.randf_range(camera_position.x - 100, camera_position.x + viewport_size.x + 100)
	var random_spawn_y_coord = random.randf_range(camera_position.y - 30, camera_position.y - 200)

	var enemy := _get_random_enemy()
	enemy.global_position = Vector2(random_spawn_x_coord, random_spawn_y_coord)
	enemy.player = player
	enemy.projectiles_container = projectiles_container
	enemy.health_component.max_health = 10
	enemy.health_component.died.connect(_on_enemy_died)
	enemy.took_damage.connect(_on_enemy_took_damage)
	enemies_container.add_child(enemy)

	spawn_timer.start()


func _get_random_enemy() -> Enemy:
	var index := random.randi_range(0, enemies.size() - 1)
	var enemy: Enemy = enemies[index].instantiate()
	return enemy


func _on_enemy_died():
	emit_signal("enemy_died")


func _on_enemy_took_damage(enemy: Character):
	emit_signal("enemy_took_damage", enemy)
