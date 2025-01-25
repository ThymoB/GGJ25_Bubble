extends Node

const SPEECH_BUBBLE = preload("res://Assets/Dialogue/SpeechBubble.tscn")
@export var BUBBLE_OFFSET:=Vector2(350,150)
@export var random_pos:=50.0
@export_category("Blurbs")
@export var blurb_chance:=0.25
@export var blurbs:Array[Dialogue]
@export var blurb_cooldown:= 5.0

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var blurb_timer: Timer = $BlurbTimer

var playing_dialogue:Dialogue
var current_bubble:SpeechBubble

func play_dialogue(dialogue:Dialogue):
	stop_current_dialogue()
	audio_stream_player.stream = dialogue.audio_clip
	playing_dialogue = dialogue
	current_bubble = SPEECH_BUBBLE.instantiate()
	get_tree().root.add_child(current_bubble)
	current_bubble.global_position = BUBBLE_OFFSET + Vector2(randf_range(-random_pos, random_pos), randf_range(-random_pos, random_pos))
	current_bubble.populate(dialogue)
	audio_stream_player.play()

func stop_current_dialogue():
	if audio_stream_player.playing:
		audio_stream_player.stop()
	playing_dialogue = null
	if current_bubble:
		current_bubble.queue_free()
	current_bubble = null

func try_play_blurb():
	if blurb_timer.is_stopped():
		if randf() <= blurb_chance:
			if !blurbs.is_empty():
				play_blurb()

func play_blurb():
	blurb_timer.start(blurb_cooldown)
	var random_blurb = blurbs.pick_random()
	play_dialogue(random_blurb)
	blurbs.erase(random_blurb)
