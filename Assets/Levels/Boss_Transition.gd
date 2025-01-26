extends AnimationPlayer

func transition():
	print("anim finished")
	get_tree().change_scene_to_file("res://Assets/Levels/BossLevel.tscn")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("BossTransitionAnim")
