extends AudioStreamPlayer

var chop_wood: = preload("res://assets/sounds/chop_wood.wav")
var swing: = preload("res://assets/sounds/swing.wav")

func play_swing() -> void:
	stream = swing
	play()

func play_chop_wood() -> void:
	stream = chop_wood
	play()
