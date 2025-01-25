extends Node2D

class_name Bubble

@export var UNPOPPED_IMG:Texture2D = preload("res://Assets/Bubbles/unpopped_bubble_1.png")
@export var POPPED_IMG:Texture2D = preload("res://Assets/Bubbles/popped_bubble_1.png")
@export var pop_sounds:Array[AudioStream]
@onready var effect_sprite: AnimatedSprite2D = $EffectSprite

@onready var area_2d: Area2D = $Area2D

@export var selected_animation: String = ""

func get_animation_list() -> Array:
	if effect_sprite:
		return effect_sprite.sprite_frames.get_animation_names()
	return []

var bubble_manager:BubbleManager

@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	rotate(randf_range(0,360))

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
	area_2d.queue_free()
	effect_sprite.visible = true
	effect_sprite.global_position = global_position
	effect_sprite.play(selected_animation)
