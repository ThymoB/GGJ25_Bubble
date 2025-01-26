extends Bubble

@export var max_health : int = 7
var current_health : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	pass # Replace with function body.

func pop():
	current_health -= 1
	$Sprite.frame = current_health
	if current_health <= 0:
		bubble_manager.bubbles_popped += 1
		sprite.texture = POPPED_IMG
		audio_stream_player.pitch_scale = randf_range(0.75,1.25)
		audio_stream_player.stream = pop_sounds.pick_random()
		audio_stream_player.play()
		bubble_manager.on_bubble_popped(self)
		area_2d.queue_free()
		effect_particle.global_position = global_position
		effect_particle.emitting = true
		count_particle.amount = 6
		
		$CountParticle/SubViewport/Label.text = str(bubble_manager.bubbles_popped)
		count_particle.emitting = true
