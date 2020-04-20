extends KinematicBody2D
class_name PickableObject

export (bool) var flammable = false
export (int) var mass = 1

func use(target: PhysicsBody2D) -> bool:
	return target.apply(self)

func apply(_object: PickableObject) -> bool:
	return false
