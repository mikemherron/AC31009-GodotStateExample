extends PlayerState

class_name PlayerStateCharging

const ChargeRate : float = 120.0

var charge_power : float

func on_enter(_data : Dictionary) -> void:
	animated_sprite.modulate = Color.red
	charge_power = 0
	
func on_process(delta : float):
	charge_power += delta * ChargeRate
	if !Input.is_action_pressed("charge"):
		var dash_data : Dictionary = {
			"dash_force" : charge_power,
			"dash_direction" : player.position.direction_to(player.get_global_mouse_position()).normalized()
		}
		return PlayerStateChange.new(PlayerState.States.Dashing, dash_data)
	return null

func on_hit() -> void:
	health.take_damage()
	if health.health>0:
		hit_sound.play()
