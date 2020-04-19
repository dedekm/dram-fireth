extends KinematicBody2D

export (int) var speed = 200

var velocity: = Vector2()
var picked_up_object: PickableObject

onready var pick_up_area = $PickUpArea

func get_input() -> void:
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
#
func pick_up(object: PickableObject) -> void:
	object.get_parent().remove_child(object)
	pick_up_area.add_child(object)
	picked_up_object = object
	object.position = Vector2(0, 0)

func drop() -> void:
	pick_up_area.remove_child(picked_up_object)
	get_parent().add_child(picked_up_object)
	picked_up_object.position = position + pick_up_area.position
	picked_up_object = null
#
func _physics_process(_delta: float) -> void:
	get_input()
	velocity = move_and_slide(velocity)
#
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('pick_up'):
		if picked_up_object:
			drop()
		else:
			for area in pick_up_area.get_overlapping_areas():
				if area.get_class() == 'PickableObject':
					pick_up(area)
#
