extends StaticBody2D

export (int) var power = 1

func _process(delta: float) -> void:
	if power <= 0:
		# TODO
		print_debug('GAME OVER')
	
func burn(object: Node) -> void:
	print_debug('FIREEE ' + object.name)
		
	if object.flammable:
		power += object.mass
		object.queue_free()
	else:
		power -= object.mass
		
	print_debug('Fire power' + String(power))
	
	_update_particles()

func _on_FireArea_body_entered(body: Node) -> void:
	burn(body)

func _update_particles() -> void:
	$FireParticles.amount = 100 + power * 2
	$FireParticles.lifetime = 1 + power * 0.1
	$FireParticles. emission_rect_extents.x = 1 + power * 0.5
	
	