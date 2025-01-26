extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_texture
	match HandSkinManager.selected_arm_skin:
		0:
			new_texture = preload("res://Assets/Hand/arm-2.png")
		1:
			new_texture = preload("res://Assets/Hand/arm-1.png")
		2:
			new_texture = preload("res://Assets/Hand/arm-3.png")
		3:
			new_texture = preload("res://Assets/Hand/arm-4.png")
	self.texture = new_texture
