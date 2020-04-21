extends StaticBody2D

export (int) var power = 1

var end_timer: Timer
var end_ready: = false
var asmr_timer: Timer
var asmr_final: = preload("res://assets/sounds/asmr/burnwithme.wav")
var asmr_files: = [
	preload("res://assets/sounds/asmr/ajajajajaaj.wav"),
	preload("res://assets/sounds/asmr/buuuuurn.wav"),
	preload("res://assets/sounds/asmr/chmmm.wav"),
	preload("res://assets/sounds/asmr/iwantmorewood.wav"),
	preload("res://assets/sounds/asmr/mmmmm.wav"),
	preload("res://assets/sounds/asmr/mmmyes.wav"),
	preload("res://assets/sounds/asmr/ooo.wav"),
	preload("res://assets/sounds/asmr/yesss.wav"),
]

func _ready():
	$FireSoundPlayer.play()

func _process(_delta: float) -> void:
	if power <= 0:
		# TODO
		print_debug('GAME OVER')

func show_fire_person() -> void:
	$FirePersonSprite.visible = true
	$FirePersonSprite.play()

	end_timer = Timer.new()
	end_timer.connect('timeout', self, '_set_end_ready')
	add_child(end_timer)
	end_timer.start(1)

func _set_end_ready() -> void:
	end_ready = true
	end_timer.queue_free()

	for body in $FireArea.get_overlapping_bodies():
		if body.name == 'Player':
			_end(body)
			return

func _end(player: Node) -> void:
	player.disabled = true
	player.visible = false

	$AsmrPlayer.stream = asmr_final
	$AsmrPlayer.play()

	$FirePersonSprite.play('burning')

func burn(object: Node) -> void:
	if object.name == 'Player':
		if power > 50 and end_ready:
			_end(object)
		return

	print_debug('FIREEE ' + object.name)

	if object.flammable:
		power += object.mass
		object.burn()

		if power > 10:
			_set_asmr_timer(0.5)

		if power >= 50:
			show_fire_person()
	else:
		power -= object.mass

	print_debug('Fire power' + String(power))

	_update_particles()

func _set_asmr_timer(delay: float) -> void:
	if not $AsmrPlayer.playing:
		asmr_timer = Timer.new()
		asmr_timer.connect('timeout', self, '_play_asmr_sound')
		add_child(asmr_timer)
		asmr_timer.start(0.5)

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
