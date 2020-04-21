extends StaticBody2D

export (int) var power = 1

var asmr_timer: Timer
var asmr_files: = [
	preload("res://assets/sounds/asmr/ajajajajaaj.wav"),
	preload("res://assets/sounds/asmr/burnwithme.wav"),
	preload("res://assets/sounds/asmr/buuuuurn.wav"),
	preload("res://assets/sounds/asmr/iwantmorewood.wav")
]

func _ready():
	$FireSoundPlayer.play()

func _process(_delta: float) -> void:
	if power <= 0:
		# TODO
		print_debug('GAME OVER')
	
func burn(object: Node) -> void:
	if object.name == 'Player':
		return

	print_debug('FIREEE ' + object.name)
		
	if object.flammable:
		power += object.mass
		object.burn()
		
		asmr_timer = Timer.new()
		asmr_timer.connect('timeout', self, '_play_asmr_sound')
		add_child(asmr_timer)
		asmr_timer.start(1)
	else:
		power -= object.mass
		
	print_debug('Fire power' + String(power))
	
	_update_particles()

func _play_asmr_sound() -> void:
	var i: = randi() % asmr_files.size()
	var res = asmr_files[i]
#	asmr_files.remove(i)
	$AsmrPlayer.stream = res
	$AsmrPlayer.play()
	
	asmr_timer.queue_free()
	

func _on_FireArea_body_entered(body: Node) -> void:
	burn(body)

func _update_particles() -> void:
	$FireParticles.amount = 100 + power * 4
	$FireParticles.lifetime = 1 + power * 0.07
	$FireParticles.emission_rect_extents.x = 1 + power * 0.2
	
	$SmokeParticles.amount = 100 + power * 5
	$SmokeParticles.lifetime = 1 + power * 0.1
	$SmokeParticles.emission_rect_extents.x = 1 + power * 0.3
