extends Control

signal applied()
@export var backdrop: TextureRect
@export var title: Control
@export var audio_section: Control
@export var button: Control
@export var music: AudioStreamPlayer
@export var sfx_slider: HSlider
@export var music_slider: HSlider

var _shine_material: ShaderMaterial = load("res://modules/levels/assets/shaders/shine_material.tres")
@onready var settings_singleton: GlobalSettings = get_node("/root/Settings")
@onready var hit_sfx: AudioStreamPlayer = $HitSound


func _ready():
	music.volume_db = settings_singleton.music_volume
	settings_singleton.music_volume_changed.connect(_handle_music_volume_change)
	settings_singleton.sound_effects_volume_changed.connect(_handle_sound_effects_volume_change)
	sfx_slider.value = settings_singleton.sound_effects_volume
	music_slider.value = settings_singleton.music_volume
	var tween := create_tween()
	tween.tween_method(_fade_backdrop_in, Color(0,0,0,0), Color(1,1,1,1), .3)
	tween.tween_method(func(value: float): _slide_up(title, value), title.position.y, 0, .6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_method(func(value: float): _slide_up(audio_section, value), audio_section.position.y, 76, .6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_method(func(value: float): _slide_up(button, value), button.position.y, 160, .3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	return


func _fade_backdrop_in(value: Color):
	backdrop.modulate = value


func _slide_up(element: Control, value: float):
	element.position.y = value


func _on_sound_effect_slider_value_changed(value: float) -> void:
	settings_singleton.change_sound_effects_volume(value)


func _on_music_slider_value_changed(value: float) -> void:
	settings_singleton.change_music_volume(value)


func _handle_music_volume_change(volume: float):
	music.volume_db = volume


func _handle_sound_effects_volume_change(volume: float):
	hit_sfx.volume_db = volume
	hit_sfx.play()



func _on_apply_mouse_entered():
	button.material = _shine_material
	button.get_child(0).scale = Vector2(1.05, 1.05)
	var tween := create_tween()
	tween.tween_method(_try_again_shine_progress, 0.0, 1.0, .6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(_try_again_shine_size, 0.01, 0.03, .6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _try_again_shine_progress(value: float) -> void:
	(button.material as ShaderMaterial).set_shader_parameter("shine_progress", value)


func _try_again_shine_size(value: float) -> void:
	(button.material as ShaderMaterial).set_shader_parameter("shine_progress", value)


func _on_apply_mouse_exited():
	button.get_child(0).scale = Vector2(1, 1)
	button.material = _shine_material


func _on_apply_pressed():
	emit_signal("applied")
