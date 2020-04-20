extends DestuctableObject

var branch: = preload('res://src/objects/Branch.tscn')
var logg: = preload('res://src/objects/Log.tscn')

func _ready():
	scraps = [
		[ logg, Vector2(0, -20) ],
		[ logg, Vector2(0, -45) ],
		[ branch, Vector2(0, -70) ]
	]
