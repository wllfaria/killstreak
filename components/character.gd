class_name Character
extends CharacterBody2D

signal took_damage(character: Character)
var hurt_material: ShaderMaterial = preload("res://modules/assets/hurt_material.tres")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_duration: Timer = $Timers/HurtDuration
@onready var hit_sfx: AudioStreamPlayer = $Sounds/Hit
@onready var die_sfx: AudioStreamPlayer = $Sounds/Die
@onready var global_settings = get_node("/root/Settings")


func play_hurt_animation():
	hurt_duration.start()
	hit_sfx.play()
	material = hurt_material
	emit_signal("took_damage", self)


func _on_hurt_duration_timeout():
	material = null
