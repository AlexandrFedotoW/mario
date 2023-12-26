extends Enemy

@onready var death_sfx = $DeathMusic

var is_dead = false

func die():
	if !is_dead:
		super.die()
		death_sfx.play()
