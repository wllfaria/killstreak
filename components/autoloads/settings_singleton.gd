class_name GlobalSettings
extends Node

signal music_volume_changed(new_volume: float)
signal sound_effects_volume_changed(new_volume: float)

var music_volume: float = 0
var sound_effects_volume: float = 0


func change_music_volume(value: float):
	music_volume = value
	emit_signal("music_volume_changed", value)


func change_sound_effects_volume(value: float):
	sound_effects_volume = value
	emit_signal("sound_effects_volume_changed", value)
