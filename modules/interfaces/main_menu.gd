extends Control

@export var settings: TextureButton
@export var play: TextureButton
@export var _settings: PackedScene
@export var settings_container: Control
@export var title: Control
@export var menus: Control
var _level_one = load("res://modules/levels/level-one/level-one.tscn")
@onready var music: AudioStreamPlayer = $Music
@onready var hover_effect: AudioStreamPlayer = $HoverEffect
@onready var global_settings = get_node("/root/Settings")


func _ready():
	global_settings.music_volume_changed.connect(_on_music_volume_changed)
	global_settings.sound_effects_volume_changed.connect(_on_sound_effects_volume_changed)


func _on_settings_mouse_entered() -> void:
	hover_effect.play()
	settings.scale = Vector2(1.05, 1.05)
	var tween := create_tween()
	tween.tween_method(_settings_shine_progress, 0.0, 1.0, .6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(_settings_shine_size, 0.01, 0.13, .6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _settings_shine_progress(value: float) -> void:
	(settings.material as ShaderMaterial).set_shader_parameter("shine_progress", value)


func _settings_shine_size(value: float) -> void:
	(settings.material as ShaderMaterial).set_shader_parameter("shine_progress", value)


func _on_settings_mouse_exited() -> void:
	settings.scale = Vector2(1, 1)


func _on_play_mouse_entered() -> void:
	hover_effect.play()
	play.scale = Vector2(1.05, 1.05)
	var tween := create_tween()
	tween.tween_method(_play_shine_progress, 0.0, 1.0, .6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(_play_shine_size, 0.01, 0.13, .6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _play_shine_progress(value: float) -> void:
	(play.material as ShaderMaterial).set_shader_parameter("shine_progress", value)


func _play_shine_size(value: float) -> void:
	(play.material as ShaderMaterial).set_shader_parameter("shine_progress", value)


func _on_play_mouse_exited() -> void:
	play.scale = Vector2(1, 1)


func _on_settings_pressed():
	music.stop()
	title.visible = false
	menus.visible = false
	var local_settings = _settings.instantiate()
	local_settings.applied.connect(_on_settings_closed)
	settings_container.add_child(local_settings)


func _on_play_pressed():
	get_tree().change_scene_to_packed(_level_one)


func _on_settings_closed() -> void:
	title.visible = true
	menus.visible = true
	music.play()
	for child in settings_container.get_children():
		child.queue_free()


func _on_music_volume_changed(volume: float) -> void:
	music.volume_db = volume


func _on_sound_effects_volume_changed(volume: float) -> void:
	hover_effect.volume_db = volume


func _on_music_finished():
	music.play()
