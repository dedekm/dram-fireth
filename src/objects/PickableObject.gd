extends KinematicBody2D
class_name PickableObject

export (bool) var flammable = false
export (int) var mass = 1

func burn() -> void:
	var parent: = get_parent()
	
	if parent.name == 'PickUpArea':
		parent.get_parent().picked_up_object = null

	queue_free()

func use(target: PhysicsBody2D) -> bool:
	return target.apply(self)

func apply(_object: PickableObject) -> bool:
	return false
