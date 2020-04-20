extends KinematicBody2D

export (int) var speed = 200
export (int) var throw_force = 500

var velocity: = Vector2()
var direction: String
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
		$YSort/InHand.position.x = 8
	if Input.is_action_pressed('left'):
		velocity.x -= 1
		$YSort/InHand.position.x = -8
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _update_chop_position(x: float, y: float, angle: int) -> void:
	var chop: = $YSort/Chop
	var chop_sprite: = $YSort/Chop/ChopSprite

	pick_up_area.set_rotation_degrees(angle)

	chop_sprite.position.x = x * 5
	chop_sprite.position.y = y * 5
	chop_sprite.set_rotation_degrees(angle)
	
	if y != 1:
		chop.position.y = -1
		chop_sprite.flip_v = true
		$YSort/InHand.position.y = -1
	else:
		chop.position.y = 0
		chop_sprite.flip_v = false
		$YSort/InHand.position.y = 1

func change_animation() -> void:
	if velocity != Vector2.ZERO:
		if not $AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()

		$YSort/PlayerSprite.set_flip_h(false)
		var angle = int(rad2deg(velocity.angle()))
		match angle:
			-135:
				_set_animation('up_right')
				$YSort/PlayerSprite.set_flip_h(true)
				_update_chop_position(-1, -1, angle)
			-90:
				_set_animation('up')
				_update_chop_position(0, -1, angle)
			-45:
				_set_animation('up_right')
				_update_chop_position(1, -1, angle)
			0:
				_set_animation('right')
				_update_chop_position(1, 0, angle)
			45:
				_set_animation('down_right')
				_update_chop_position(1, 1, angle)
			90:
				_set_animation('down')
				_update_chop_position(0, 1, angle)
			135:
				_set_animation('down_right')
				$YSort/PlayerSprite.set_flip_h(true)
				_update_chop_position(-1, 1, angle)
			180:
				_set_animation('right')
				$YSort/PlayerSprite.set_flip_h(true)
				_update_chop_position(-1, 0, angle)
	else:
		if $AudioStreamPlayer.playing:
			$AudioStreamPlayer.stop()
		$YSort/PlayerSprite.stop()

func _set_animation(name: String) -> void:
	if picked_up_object or name == 'up':
		$YSort/PlayerSprite.play(name)
	else:
		$YSort/PlayerSprite.play(name + '_axe')

func use_axe() -> void:
	$YSort/Chop/ChopSprite.visible = true
	$YSort/Chop/ChopSprite.play()

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
	$YSort/PlayerSprite.play($YSort/PlayerSprite.animation.trim_suffix('_axe'))
	object.picked_up()
	$YSort/InHand.add_child(object)
	picked_up_object = object
	object.position = Vector2(0, 0)

func drop() -> void:
	$YSort/InHand.remove_child(picked_up_object)
	picked_up_object.dropped()
	get_parent().add_child(picked_up_object)
	picked_up_object.position = $YSort/InHand.get_global_position()
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

func _on_ChopSprite_animation_finished() -> void:
	$YSort/Chop/ChopSprite.stop()
	$YSort/Chop/ChopSprite.visible = false
