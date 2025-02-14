extends Node

const SPEECH_BUBBLE = preload("res://Assets/Dialogue/SpeechBubble.tscn")

@export var BUBBLE_OFFSET:=Vector2(350,150)
@export var random_pos:=50.0
@export_category("Blurbs")
@export var blurbs:Array[Dialogue]
@export var blurb_chance:=0.25
@export var blurb_cooldown:= 5.0

@export_category("Idle")
@export var idle_lines:Array[Dialogue]
@export var idle_time:=15.0 # Timeout when it should start playing idle lines

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var blurb_timer: Timer = $BlurbTimer
@onready var idle_timer: Timer = $IdleTimer

var playing_dialogue:Dialogue
var current_bubble:SpeechBubble

func _ready():
	GameManager.on_bubble_manager_created.connect(on_bubble_manager_created)

func on_bubble_manager_created(bubble_manager:BubbleManager):
	start_idle_line_timer(null)
	bubble_manager.bubble_popped_signal.connect(start_idle_line_timer)

func start_idle_line_timer(_bubble):
	# Stop Idle dialogue if bubble clicked when idle dialogue is showing
	if current_bubble and idle_lines.has(current_bubble.dialogue):
		stop_current_dialogue()
	idle_timer.stop()
	idle_timer.start(idle_time)

func play_dialogue(dialogue:Dialogue):
	stop_current_dialogue()
	audio_stream_player.stream = dialogue.audio_clip
	playing_dialogue = dialogue
	current_bubble = SPEECH_BUBBLE.instantiate()
	get_tree().root.add_child(current_bubble)
	current_bubble.global_position = BUBBLE_OFFSET + Vector2(randf_range(-random_pos, random_pos), randf_range(-random_pos, random_pos))
	current_bubble.populate(dialogue)
	dialogue.on_triggered()
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
			play_blurb()

func play_blurb():
	var eligible_blurbs:Array[Dialogue] = blurbs.filter(func(blurb:Dialogue):
		return !blurb.unique_to_act or blurb.act == GameManager.get_current_act())
	if eligible_blurbs.is_empty():
		return
	blurb_timer.start(blurb_cooldown)
	var random_blurb = eligible_blurbs.pick_random()
	play_dialogue(random_blurb)
	blurbs.erase(random_blurb)

func _on_idle_timer_timeout() -> void:
	play_dialogue(idle_lines[0])
	idle_lines.remove_at(0)
	idle_timer.start(7.0)
