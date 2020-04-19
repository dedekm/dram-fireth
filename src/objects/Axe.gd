extends PickableObject

func use() -> void:
	for body in get_overlapping_bodies():
		if not body.name == 'Player':
			body.apply(self)
