extends PlayerState

class_name PlayerStateDashing

const ChargeFriction : float = 0.75

var dash_direction : Vector2
var dash_force : float

func on_enter(data : Dictionary) -> void:
	dash_direction = data['dash_direction']
	dash_force = data['dash_force']

func on_process(delta : float):
	animated_sprite.modulate = Color(randf(), randf(), randf())
	animated_sprite.rotate(dash_force / 250)
	player.move_and_slide(dash_direction * dash_force)
	if player.get_slide_count() > 0:
		var collision : KinematicCollision2D = player.get_slide_collision(0)
		if collision != null:
			if collision.collider.is_in_group("turret"):
				collision.collider.queue_free()
			dash_direction = dash_direction.bounce(collision.normal)

	dash_force = dash_force * (1-ChargeFriction*delta)
	if dash_force < 15:
		return PlayerStateChange.new(PlayerState.States.Normal)
	return null
