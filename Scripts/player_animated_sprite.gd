extends AnimatedSprite2D

class_name PlayerAnimatedSprite

@warning_ignore("unused_parameter")
func trigger_animation(velocity: Vector2, direction: int, player_mode: Player.PlayerMode):
	
	if not get_parent().is_on_floor():
		print("Jump animation")
		play("jump")
	elif velocity.x != 0:
		print("Run animation")
		play("walk")
	else:
		print("Idle animation")
		play("idle")
