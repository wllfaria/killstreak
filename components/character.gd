class_name Character
extends CharacterBody2D

var hurt_material: ShaderMaterial = preload("res://modules/characters/assets/hurt_material.tres")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_duration: Timer = $Timers/HurtDuration


func play_hurt_animation():
	hurt_duration.start()
	material = hurt_material


func _on_hurt_duration_timeout():
	material = null
