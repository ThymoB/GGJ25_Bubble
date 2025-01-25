extends Node2D

class_name Bubble

@export var UNPOPPED_IMG:Texture2D = preload("res://Assets/Bubbles/unpopped_bubble_1.png")
@export var POPPED_IMG:Texture2D = preload("res://Assets/Bubbles/popped_bubble_1.png")
@export var pop_sounds:Array[AudioStream]


var bubble_manager:BubbleManager

@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	rotate(randf_range(0,360))

'''
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed: # Make sure this works for Android
			if !is_popped():
				pop()
'''

func is_popped()->bool:
	return sprite.texture != UNPOPPED_IMG

func pop():
	bubble_manager.bubbles_popped += 1
	print("Bubbles popped: " + str(bubble_manager.bubbles_popped))
	sprite.texture = POPPED_IMG
	audio_stream_player.pitch_scale = randf_range(0.75,1.25)
	audio_stream_player.stream = pop_sounds.pick_random()
	audio_stream_player.play()
	bubble_manager.on_bubble_popped(self)
