extends Node2D

class_name Bubble

var bubble_manager:BubbleManager

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	rotate(randf_range(0,360))

func _process(_delta: float) -> void:
	if is_instance_valid(sprite):
		if sprite.get_rect().has_point(get_global_mouse_position()):
			if Input.is_action_pressed("click"):
				pop()

func pop():
	bubble_manager.bubbles_popped += 1
	print("Bubbles popped: " + str(bubble_manager.bubbles_popped))
	queue_free()
