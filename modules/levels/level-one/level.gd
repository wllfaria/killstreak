extends Node2D

@export var camera: Camera2D
@export var player: Player
@export var background: ParallaxBackground
@export var tilemap: TileMap
@export var projectiles: Node
@export var monsters: Node
@export var forcefields: Control
@export var died_title: TextureRect
@export var try_again: TextureButton
@export var damage_indicators: Control
@export var health_bar: TextureProgressBar
@export var pause_container: Control
@export var _settings: PackedScene
@export var enemies_spawner: SpawnEnemies
@export var game_over: Control
@export var you_win_scene: PackedScene

var _is_player_dead := false
var _interface_animation_finished := false
var _damage_indicator_label: PackedScene = preload("res://modules/levels/components/damage_label.tscn")
var _is_paused := false

@onready var music = $Music
@onready var game_over_music = $GameOverMusic
@onready var global_settings = get_node("/root/Settings")


func _ready():
	global_settings.music_volume_changed.connect(_on_music_volume_changed)
	music.volume_db = global_settings.music_volume
	game_over_music.volume_db = global_settings.music_volume


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not _is_paused:
			game_over.visible = false
			forcefields.process_mode = forcefields.PROCESS_MODE_PAUSABLE
			player.process_mode = player.PROCESS_MODE_PAUSABLE
			_is_paused = true
			health_bar.visible = false
			game_over_music.stop()
			music.stop()
			get_tree().paused = true
			var settings = _settings.instantiate()
			settings.applied.connect(_on_settings_closed)
			pause_container.add_child(settings)
		else:
			player.process_mode = player.PROCESS_MODE_ALWAYS
			forcefields.process_mode = forcefields.PROCESS_MODE_ALWAYS
			game_over.visible = true
			_on_settings_closed()



func _on_player_died() -> void:
	music.stop()
	game_over_music.play()
	player.disable_controls()
	_is_player_dead = true
	var tween := create_tween()
	projectiles.queue_free()
	monsters.queue_free()
	forcefields.queue_free()
	health_bar.queue_free()
	get_tree().paused = true
	tween.set_parallel(true)
	for layer in background.get_children():
		tween.tween_property(layer, "modulate", Color(0, 0, 0, 1), .3).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(player, "global_position", Vector2(160, 150), .3)
	tween.tween_property(tilemap, "modulate", Color(0, 0, 0, 1), .3).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(tilemap, "modulate", Color(0, 0, 0, 1), .3).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "limit_bottom", 182, .15).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "zoom", Vector2(2.5, 2.5), .6).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	player.animation_player.play("Die")
	await player.animation_player.animation_finished
	player.process_mode = Player.PROCESS_MODE_PAUSABLE
	var interface_tween := create_tween()
	try_again.process_mode = try_again.PROCESS_MODE_ALWAYS
	interface_tween.tween_property(died_title, "position:y", 24, .6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	interface_tween.tween_property(try_again, "position:y", 140, .3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	await interface_tween.finished
	_interface_animation_finished = true


func _on_try_again_mouse_entered() -> void:
	try_again.scale = Vector2(1.05, 1.05)
	var tween := create_tween()
	tween.tween_method(_try_again_shine_progress, 0.0, 1.0, .6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(_try_again_shine_size, 0.01, 0.13, .6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _try_again_shine_progress(value: float) -> void:
	(try_again.material as ShaderMaterial).set_shader_parameter("shine_progress", value)


func _try_again_shine_size(value: float) -> void:
	(try_again.material as ShaderMaterial).set_shader_parameter("shine_progress", value)


func _on_try_again_mouse_exited() -> void:
	try_again.scale = Vector2(1, 1)


func _on_try_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_left_forcefield_player_smashed() -> void:
	_on_player_died()


func _on_right_forcefield_player_smashed() -> void:
	_on_player_died()


func _on_spawn_enemies_enemy_died():
	for forcefield in forcefields.get_children():
		(forcefield as ShrinkingWall).lose_progress()


func _on_player_took_damage(_player: Character) -> void:
	var label = _damage_indicator_label.instantiate() as Label
	label.text = "12"
	label.label_settings.font_color = Color.from_string("#a53030", Color(0, 0, 0, 1))
	label.position = player.get_global_transform_with_canvas().origin
	damage_indicators.add_child(label)


func _on_spawn_enemies_enemy_took_damage(enemy: Character):
	var label = _damage_indicator_label.instantiate() as Label
	label.text = "3"
	label.label_settings.font_color = Color.from_string("#de9e41", Color(0, 0, 0, 1))
	label.position = enemy.get_global_transform_with_canvas().origin
	damage_indicators.add_child(label)


func _on_kill_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		_on_player_died()


func _on_settings_closed() -> void:
	_is_paused = false
	get_tree().paused = false
	music.play()
	health_bar.visible = true
	for child in pause_container.get_children():
		child.queue_free()


func _on_music_volume_changed(volume: float) -> void:
	music.volume_db = volume
	game_over_music.volume_db = volume



func _on_finish_line_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_packed(you_win_scene)
