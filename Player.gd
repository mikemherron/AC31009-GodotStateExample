extends KinematicBody2D

class_name Player

var state : PlayerState

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var hit_sound : AudioStreamPlayer = $HitSound
onready var health : Health = $Health

# Godot 3.5 has trouble managing cyclical dependencies between classes,
# this makes it difficult to have states return the next state on a state
# change when they inherit from a common base class. Instead, we create
# the states as Child nodes of the player, and get a reference to them 
# here. States return a PlayerStateChange object which indicates what
# state they should change to , and the player finds the existing state
# object from this dictionary.
onready var states : Dictionary = {
	PlayerState.States.Normal  : $States/PlayerStateNormal,
	PlayerState.States.Charging : $States/PlayerStateCharging,
	PlayerState.States.Dashing : $States/PlayerStateDashing
}

func _ready():
	# Set a reference to the player on each state. Due to the order
	# nodes initialize in, it's simplest to do this here.
	for state in states.values():
		state.set_player(self)
		
	# Start in the normal state
	state = states[PlayerState.States.Normal] as PlayerState
	state.on_enter({})
	
func _process(delta):
	var state_change : PlayerStateChange = state.on_process(delta)
	# If a state change has been returned, get the new state from
	# the states dictionary, set it as the current state and call
	# enter, passing in any state change data provided from the 
	# previous state
	if state_change!=null:
		state = states[state_change.state] as PlayerState
		state.on_enter(state_change.data) 

func hit() -> void:
	state.on_hit()
