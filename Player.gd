extends KinematicBody2D

class_name Player

onready var bullet_scene = preload("res://Bullet.tscn")
onready var health : Health = $Health

var speed : int = 30
var movement : Vector2

const ChargeRate : float = 120.0
const ChargeFriction : float = 0.75

var is_dashing : bool = false 
var is_charging : bool = false;
var is_normal : bool = true;

var dash_direction : Vector2
var dash_force : float
var charge_power : float

onready var animation : AnimatedSprite = $AnimatedSprite

func _process(delta):
	if Input.is_action_pressed("charge") && !is_dashing:
		is_charging = true
		is_normal = false
		is_dashing = false
		charge_power += delta * ChargeRate
		$AnimatedSprite.modulate = Color.red
	elif is_charging:
		is_charging = false
		is_dashing = true
		is_normal = false
		dash_force = charge_power
		charge_power = 0
		dash_direction = position.direction_to(get_global_mouse_position()).normalized()
		
	if is_dashing:
		$AnimatedSprite.modulate = Color(randf(), randf(), randf())
		$AnimatedSprite.rotate(dash_force / 250)
		move_and_slide(dash_direction * dash_force)
		if get_slide_count() > 0:
			var collision : KinematicCollision2D = get_slide_collision(0)
			if collision != null:
				if collision.collider.is_in_group("turret"):
					collision.collider.queue_free()
				dash_direction = dash_direction.bounce(collision.normal)

		dash_force = dash_force * (1-ChargeFriction*delta)
		if dash_force < 15:
			is_dashing = false
			is_normal = true
			is_charging = false
			$AnimatedSprite.rotation = 0
			$AnimatedSprite.modulate = Color.white
		
	if is_normal:
		var last_movement : Vector2 = movement
		movement = Vector2.ZERO
		if Input.is_action_pressed("ui_up"):
			movement.y=-1
		if Input.is_action_pressed("ui_down"):
			movement.y=1
		if Input.is_action_pressed("ui_left"):
			movement.x=-1
		if Input.is_action_pressed("ui_right"):
			movement.x=1
		movement = movement.normalized()
		if movement != last_movement:
			_update_animation()
		move_and_slide(movement * speed)
	
	if is_normal && Input.is_action_just_pressed("click"):
		var bullet : Bullet = bullet_scene.instance()
		owner.add_child(bullet)
		bullet.bullet_owner = self
		bullet.speed*=2
		bullet.direction = position.direction_to(get_global_mouse_position())
		bullet.global_position = global_position

func _update_animation() -> void:
	if movement.y > 0:
		animation.play("down")
	elif movement.y < 0:
		animation.play("up")
	elif movement.x > 0:
		animation.play("right")
	elif movement.x < 0:
		animation.play("left")
	else:
		animation.play("idle")

func hit() -> void:

	health.take_damage()
	if health.health>0:
		$HitSound.play()

