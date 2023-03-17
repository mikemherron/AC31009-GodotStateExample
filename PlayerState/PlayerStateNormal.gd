extends PlayerState

class_name PlayerStateNormal

var bullet_scene = preload("res://Bullet.tscn")

var speed : int = 30
var movement : Vector2
	
func on_enter(_data : Dictionary) -> void:
	animated_sprite.rotation = 0
	animated_sprite.modulate = Color.white
	
func on_process(_delta : float):
	if Input.is_action_pressed("charge"):
		return PlayerStateChange.new(PlayerState.States.Charging)
	
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
	player.move_and_slide(movement * speed)
	
	if Input.is_action_just_pressed("click"):
		var bullet : Bullet = bullet_scene.instance()
		player.owner.add_child(bullet)
		bullet.bullet_owner = player
		bullet.speed*=2
		bullet.direction = player.position.direction_to(player.get_global_mouse_position())
		bullet.global_position = player.global_position

	return null
	
func _update_animation() -> void:
	if movement.y > 0:
		animated_sprite.play("down")
	elif movement.y < 0:
		animated_sprite.play("up")
	elif movement.x > 0:
		animated_sprite.play("right")
	elif movement.x < 0:
		animated_sprite.play("left")
	else:
		animated_sprite.play("idle")

func on_hit() -> void:
	health.take_damage()
	if health.health>0:
		hit_sound.play()
