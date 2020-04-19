extends StaticBody2D

func apply(object: PickableObject) -> bool:
	print(object.name)
	if object.flammable and object.name != 'Axe':
		return true
	else:
		return false
