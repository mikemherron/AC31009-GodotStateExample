extends Node2D

export(NodePath) var health_path
onready var health : Health = get_node(health_path)

onready var width : float = $ColorRect.rect_size.x

func _ready():
	health.connect("health_changed", self, "on_health_changed")
	
func on_health_changed(_health_new) -> void:
	$ColorRect.rect_size.x = width * (float(health.health) / float(health.maxHealth))
