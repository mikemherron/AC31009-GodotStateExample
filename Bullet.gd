extends Area2D

class_name Bullet

var speed = 40
var direction : Vector2
var bullet_owner : Node
	
func _ready():
	connect("body_entered", self, "on_body_entered")
	
func _physics_process(delta):
	position += direction * speed * delta

func on_body_entered(body: Node):
	if !is_instance_valid(body) || !is_instance_valid(bullet_owner):
		return
	if body.is_in_group("player") && bullet_owner.is_in_group("turret"):
		body.hit()
		queue_free()
	elif body.is_in_group("turret") && bullet_owner.is_in_group("player"):
		body.hit()
		queue_free()
