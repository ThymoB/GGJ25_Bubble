extends AnimatedSprite2D


func _ready():
	animation = "your_animation_name"  # Set the animation to play
	animation_finished.connect(_on_frame_changed)  # Connect the signal

func _on_frame_changed():
	# Check if the animation is at the last frame
	if frame == sprite_frames.get_frame_count(animation) - 1:
		queue_free()  # Delete the node
