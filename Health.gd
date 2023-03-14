extends Node

class_name Health

signal health_changed

export var maxHealth : int = 10
onready var health : int = maxHealth

func take_damage() -> void:
	health-=1
	emit_signal("health_changed", health)
