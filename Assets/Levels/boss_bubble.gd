extends Bubble
class_name BossBubble
signal boss_bubble_popped_signal(bubble:Bubble)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func unpop():
	sprite.texture = UNPOPPED_IMG
	
func pop():
	if not is_popped():
		sprite.texture = POPPED_IMG
		audio_stream_player.pitch_scale = randf_range(0.75,1.25)
		audio_stream_player.stream = pop_sounds.pick_random()
		audio_stream_player.play()
		effect_particle.global_position = global_position
		effect_particle.emitting = true
		boss_bubble_popped_signal.emit(self)
