extends KinematicBody2D
class_name PickableObject

export (bool) var flammable = false
export (int) var mass = 1

func burn() -> void:
	var parent: = get_parent()
	
	if parent.name == 'InHand':
		parent.get_parent().get_parent().picked_up_object = null

	queue_free()

func picked_up() -> void:
	if $AnimatedSprite:
		$AnimatedSprite.play('carried')

func dropped() -> void:
	if $AnimatedSprite:
		$AnimatedSprite.play('default')

func use(target: PhysicsBody2D) -> bool:
	return target.apply(self)

func apply(_object: PickableObject) -> bool:
	return false
