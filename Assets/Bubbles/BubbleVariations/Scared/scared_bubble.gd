extends Bubble

@export var max_distance : float = 150.0
@export var max_shake_strength : float = 0.7  # The maximum shake distance
@export var shake_duration : float = 0.5   # How long the shake lasts
@onready var animation_player: AnimationPlayer = $Sprite/AnimationPlayer
var start_position: Vector2
# Called when the node enters the scene tree for the first time.
func _process(delta: float):
	shake() # Replace with function body.

func shake():
	if not is_instance_valid(Hand.instance) or is_popped():
		return
	var distance = global_position.distance_to(Hand.instance.global_position)
	distance = clamp(distance, 0.0, max_distance)
	var inverted_distance = max_distance - distance
	var shake_strength = lerp(0.0, max_shake_strength, inverted_distance/max_distance)
	var original_position = position
	original_position = original_position + Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	# Reset position back to the original
	position = original_position
	
