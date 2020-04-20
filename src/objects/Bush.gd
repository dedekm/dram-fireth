extends DestuctableObject

var branch: = preload('res://src/objects/Branch.tscn')

func _ready():
	scraps = [
		[ branch, Vector2(0, 0) ]
	]
