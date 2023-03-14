extends StaticBody2D

class_name Turret

export(NodePath) var target_path
export(Resource) var bullet_scene

# Just like player, we use the health node to
# keep track of the turrets health
onready var health : Health = $Health

export var fire_speed = 40

onready var fireDelay = rand_range(1.0, 2.0)

func _ready():
	_set_fire_timer()
	
func _on_fire() -> void:
	var bullet : Bullet = bullet_scene.instance()
	owner.add_child(bullet)
	bullet.bullet_owner = self
	bullet.speed = fire_speed
	bullet.direction = position.direction_to(get_node(target_path).position)
	bullet.modulate = Color.red
	bullet.global_position = global_position
	_set_fire_timer()

func hit() -> void:
	health.take_damage()
	if(health.health<=0):
		queue_free()
		
func _set_fire_timer() -> void:
	get_tree().create_timer(fireDelay).connect("timeout", self, "_on_fire")
