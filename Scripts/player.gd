extends CharacterBody2D


class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode {
	NORMAL
}

@onready var animated_sprite_2d = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var collision_shape = $BodyCollisionShape

@export_group("Locomotion")
@export var run_speed_damping = 0.5
@export var speed = 600.0
@export var jump_velocity = -700
@export_group("")

@export_group("Stomping enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -150
@export_group("")

var score : int = 0
@onready var score_label : Label = $"../ScoreLabel"


var player_mode = PlayerMode.NORMAL
var is_dead = false 


func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
		
	var direction = Input.get_axis("left", "right")
	
	if direction:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * direction
		velocity.x = lerpf(velocity.x, speed * direction, run_speed_damping * delta)
	else: 
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	animated_sprite_2d.trigger_animation(velocity, direction, player_mode)
	
			
	move_and_slide()

 
func _on_area_2d_area_entered(area):
	if area is End2:
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/end_game_menu.tscn")
		
	if area is Enemy:
		handle_enemy_collision(area)
		
func handle_enemy_collision(enemy: Enemy):
	if enemy == null && is_dead:
		return
		
	var angle_of_collision = rad_to_deg(position.angle_to_point(enemy.position))
	
	if angle_of_collision > min_stomp_degree && max_stomp_degree > angle_of_collision:
		enemy.die()
		await (get_tree().create_timer(1.0)).timeout

		enemy.queue_free()
		on_enemy_stomped()
		update_score(100)
		
	else:
		die()
		
func update_score(points: int):
	score += points
	score_label.text = str(score)
	
func on_enemy_stomped():
	velocity.x = stomp_y_velocity
		
		
func die():
	if player_mode == PlayerMode.NORMAL:
		is_dead = true
		set_collision_layer_value(1, false)
		set_physics_process(false)
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 256), 1)
		death_tween.tween_callback(func (): get_tree().reload_current_scene())
		get_tree().change_scene_to_file("res://Scenes/end_game_menu.tscn")
		
