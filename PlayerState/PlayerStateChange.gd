extends Reference

class_name PlayerStateChange

var state : int
var data : Dictionary

func _init(state : int, data : Dictionary = {}):
	self.state = state
	self.data = data
