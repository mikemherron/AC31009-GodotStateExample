extends Node2D

onready var _game_over_sound : AudioStreamPlayer = $GameOverSound
onready var _turrets : Node2D = $Turrets
onready var _player : Node2D = $Player
onready var _ui_controller : UIController = $UIController

func _ready():
	_ui_controller.set_health(_player.health.health)
	
func _on_Health_health_changed(health):
	if health <= 0:
		_turrets.queue_free()
		_player.queue_free()
		_game_over_sound.play()
