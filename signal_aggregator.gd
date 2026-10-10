extends RefCounted

signal fired


func connect_to(s: Signal) -> void:
	assert(not s.is_connected(fired.emit))
	var __ := s.connect(fired.emit)


func disconnect_from(s: Signal) -> void:
	assert(s.is_connected(fired.emit))
	s.disconnect(fired.emit)
