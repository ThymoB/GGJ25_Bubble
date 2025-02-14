extends Node2D

class_name Bubble

@export var UNPOPPED_IMG:Texture2D = preload("res://Assets/Bubbles/unpopped_bubble_1.png")
@export var POPPED_IMG:Texture2D = preload("res://Assets/Bubbles/popped_bubble_1.png")
@export var pop_sounds:Array[AudioStream]

@export var index_x: int
@export var index_y: int

@onready var effect_particle: CPUParticles2D = $EffectParticle
@onready var count_particle: CPUParticles2D = $CountParticle

@onready var area_2d: Area2D = $Area2D

var bubble_manager:BubbleManager

@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: Sprite2D = $Sprite

var popped = false

func _ready() -> void:
	rotate(randf_range(0,360))

func is_popped()->bool:
	return popped

func pop():
	popped = true
	bubble_manager.bubbles_popped += 1
	sprite.texture = POPPED_IMG
	audio_stream_player.pitch_scale = randf_range(0.75,1.25)
	audio_stream_player.stream = pop_sounds.pick_random()
	audio_stream_player.play()
	bubble_manager.on_bubble_popped(self)
	area_2d.queue_free()
	effect_particle.global_position = global_position
	effect_particle.emitting = true
	count_particle.amount = bubble_manager.bubbles_popped
	$CountParticle/SubViewport/Label.text = str(bubble_manager.bubbles_popped)
	count_particle.emitting = true
	
