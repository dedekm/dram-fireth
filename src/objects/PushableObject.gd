extends KinematicBody2D
class_name PushableObject

export (bool) var flammable = false
export (int) var mass = 1

var velocity: = Vector2()
var stopping: = false

func _physics_process(delta: float) -> void:
	if stopping:
		velocity.x -= 500 * delta
		velocity.y -= 500 * delta
		
		if velocity.x < 0:
			velocity.x = 0
		if velocity.y < 0:
			velocity.y = 0
		
		if !velocity:
			stopping = false

	velocity = move_and_slide(velocity)
#	change_animation()
