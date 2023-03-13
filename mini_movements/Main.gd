extends Node2D

func _ready():
	var camera = $Camera2D
	var limits = $"Map Limits".get_children()
	for limit in limits:
		match limit.name:
			"CameraLimitTopLeft":
				camera.limit_left = 0
				camera.limit_top = 0
			"CameraLimitBottomRight":
				camera.limit_bottom = limit.global_position.y
				camera.limit_right = limit.global_position.x
				
