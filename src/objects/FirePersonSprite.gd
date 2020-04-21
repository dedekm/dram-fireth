extends AnimatedSprite


#get_node("/root/Level").end_the_game()


func _on_animation_finished() -> void:
	if animation == 'burning':
		get_node("/root/Level").end_the_game()
		queue_free()
