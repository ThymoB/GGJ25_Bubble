extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		input_click()

func input_click():
	global_position = get_viewport().get_mouse_position()
