extends StaticBody2D

var wood: = preload('res://src/objects/Wood.tscn')

func apply(object: PickableObject) -> bool:
	if object.name == 'Axe':
		var wood_instance: = wood.instance()
		wood_instance.position = position
		get_parent().add_child(wood_instance)
		queue_free()
	
	return false
