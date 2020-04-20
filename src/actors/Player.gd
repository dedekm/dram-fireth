extends KinematicBody2D

export (int) var speed = 200
export (int) var throw_force = 500


var velocity: = Vector2()
var picked_up_object: PickableObject
var use_cooldown: = 0.0
var thrown_object_body: = preload('res://src/actors/ThrownObjectBody.tscn')

onready var pick_up_area: = $PickUpArea

func _physics_process(delta: float) -> void:
	get_input()
	cooldown(delta)
	velocity = move_and_slide(velocity)
	change_animation()

func get_input() -> void:
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
		pick_up_area.position.x = 10
	if Input.is_action_pressed('left'):
		velocity.x -= 1
		pick_up_area.position.x = -10
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func change_animation() -> void:
	if velocity != Vector2.ZERO:
		$AnimatedSprite.set_flip_h(false)
		var angle = int(rad2deg(velocity.angle()))
		match angle:
			-135:
				_set_animation('up_right')
				$AnimatedSprite.set_flip_h(true)
			-90:
				_set_animation('up')
			-45:
				_set_animation('up_right')
			0:
				_set_animation('right')
			45:
				_set_animation('down_right')
			90:
				_set_animation('down')
			135:
				_set_animation('down_right')
				$AnimatedSprite.set_flip_h(true)
			180:
				_set_animation('right')
				$AnimatedSprite.set_flip_h(true)
	else:
		$AnimatedSprite.stop()

func _set_animation(name: String) -> void:
	if picked_up_object or name == 'up':
		$AnimatedSprite.play(name)
	else:
		$AnimatedSprite.play(name + '_axe')

func use_axe() -> void:
	for body in pick_up_area.get_overlapping_bodies():
		if body is DestuctableObject:
			body.use_axe()

func throw(target: Vector2) -> void:
	if picked_up_object and use_cooldown == 0:
		var to_instance = thrown_object_body.instance()
		to_instance.position = position
		to_instance.velocity = _get_throw_vector(target)
		get_parent().add_child(to_instance)
		pick_up_area.remove_child(picked_up_object)
		to_instance.add_object(picked_up_object)

		picked_up_object = null
		use_cooldown = 0.05

func _get_throw_vector(target: Vector2) -> Vector2:
	return Vector2(throw_force, 0).rotated(get_angle_to(target))

func cooldown(delta: float) -> void:
	if use_cooldown:
		use_cooldown -= delta
		if use_cooldown < 0:
			use_cooldown = 0

func pick_up(object: PickableObject) -> void:
	object.get_parent().remove_child(object)
	$AnimatedSprite.play($AnimatedSprite.animation.trim_suffix('_axe'))
	pick_up_area.add_child(object)
	picked_up_object = object
	object.position = Vector2(0, 0)

func drop() -> void:
	pick_up_area.remove_child(picked_up_object)
	get_parent().add_child(picked_up_object)
	picked_up_object.position = pick_up_area.get_global_position()
	picked_up_object = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('use'):
		use_axe()
	elif event.is_action_pressed('pick_up'):
		if picked_up_object:
			drop()
		else:
			for body in pick_up_area.get_overlapping_bodies():
				if body is PickableObject:
					pick_up(body)
					break

func _on_PushArea_body_entered(body: Node) -> void:
	if body is PushableObject:
		print_debug('pushing ' + body.name)
		body.velocity = velocity


func _on_PushArea_body_exited(body: Node) -> void:
	if body is PushableObject:
		print_debug('stopped pushing ' + body.name)
		body.stopping = true
