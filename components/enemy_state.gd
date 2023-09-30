class_name EnemyState
extends State

var enemy: Enemy


func _ready():
	await owner.ready
	enemy = owner as Enemy
	assert(enemy != null)
