extends KinematicBody2D

var velocity: = Vector2()
var object: PickableObject
var distance: = 0.0

func add_object(obj: PickableObject) -> void:
	object = obj
	object.position = Vector2(0, 0)
	add_child(object)

func _physics_process(delta: float) -> void:
	if velocity:
		var collision: = move_and_collide(velocity * delta)
		distance += delta
		
		if collision or distance > 0.5:
			remove_child(object)
			object.position = position
			get_parent().add_child(object)
			queue_free()
			
			if collision:
				# TODO
				print(collision.collider.name)
