extends Node

class_name PlayerState

enum States {
	Normal,
	Charging,
	Dashing
}

var player : Node2D
var health : Health
var hit_sound : AudioStreamPlayer
var animated_sprite : AnimatedSprite
	
func set_player(player):
	self.player = player
	self.health = player.health
	self.hit_sound = player.hit_sound
	self.animated_sprite = player.animated_sprite
	
func on_process(_delta : float):
	pass

func on_hit() -> void:
	pass
	
func on_enter(_data : Dictionary) -> void:
	pass
