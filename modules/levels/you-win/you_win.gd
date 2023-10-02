extends Control

@export var backdrop: TextureRect
@export var title: Control
@export var thank_you: Control
@export var music: AudioStreamPlayer
@export var main_menu: PackedScene

@onready var settings_singleton: GlobalSettings = get_node("/root/Settings")

func _ready():
	music.volume_db = settings_singleton.music_volume
	settings_singleton.music_volume_changed.connect(_handle_music_volume_change)
	var tween := create_tween()
	tween.tween_method(_fade_backdrop_in, Color(0,0,0,0), Color(1,1,1,1), .3)
	tween.tween_method(func(value: float): _slide_up(title, value), title.position.y, 16, .6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_method(func(value: float): _slide_up(thank_you, value), thank_you.position.y, 0, .3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	return


func _fade_backdrop_in(value: Color):
	backdrop.modulate = value


func _slide_up(element: Control, value: float):
	element.position.y = value


func _handle_music_volume_change(volume: float):
	music.volume_db = volume


func _on_music_finished():
	music.play()


func _on_play_again_pressed():
	get_tree().change_scene_to_packed(main_menu)
