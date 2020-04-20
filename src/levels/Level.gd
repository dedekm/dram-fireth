extends Node2D

export (int) var zoom = 4

func _ready():
	var size = OS.get_real_window_size()
	OS.set_window_size(size * zoom)
	
	$WindAudioPlayer.play()
