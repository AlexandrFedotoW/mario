extends Enemy

@onready var death_sfx = $DeathMusic


func die():
	super.die()
	death_sfx.play()
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
