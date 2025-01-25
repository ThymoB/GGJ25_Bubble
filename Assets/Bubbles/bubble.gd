extends Node2D

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	rotate(randf_range(0,360))

func _process(delta: float) -> void:
	if is_instance_valid(sprite):
		if sprite.get_rect().has_point(get_global_mouse_position()):
			if Input.is_action_pressed("click"):
				sprite.queue_free()
