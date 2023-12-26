extends Area2D

class_name Enemy

var horizontal_speed = 80
var vertical_speed = 400
var score = 0
@onready var ray_cast_2d = $RayCast2D as RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D

func _process(delta):
	position.x -= delta * horizontal_speed
	if !ray_cast_2d.is_colliding():
		position.y += delta * vertical_speed

func die():
	horizontal_speed = 0
	vertical_speed = 0
	animated_sprite_2d.play("dead")
	





