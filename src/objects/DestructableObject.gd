extends StaticBody2D
class_name DestuctableObject

var destroyed: = false
var scraps: = []

func use_axe() -> void:
	if not destroyed:
		for scrap in scraps:
			create_scrap(scrap)
		destroy()

func create_scrap(scrap_array: Array) -> void:
	var scrap_instance: Node = scrap_array[0].instance()
	scrap_instance.position = position + scrap_array[1]
	get_parent().add_child(scrap_instance)

func destroy() -> void:
	print_debug(name + ' destroyed ')

	if $AnimatedSprite or $Sprite:
		if $AnimatedSprite:
			$AnimatedSprite.play('destroyed')
		elif $Sprite:
			$Sprite.frame = 1
		
		destroyed = true
	else:
		queue_free()
