extends Node2D

class_name End



func _on_area_2d_body_exited(body):
	if body is Player:
		print("asdasd") 
