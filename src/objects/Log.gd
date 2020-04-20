extends PushableObject

func _update_animation() -> void:
	if velocity.x != 0:
		$AnimatedSprite.play('vertical')
	elif velocity.y != 0:
		$AnimatedSprite.play('horizontal')
	else:
		$AnimatedSprite.stop()
