extends Node

const SPEECH_BUBBLE = preload("res://Assets/Dialogue/SpeechBubble.tscn")

@export var BUBBLE_OFFSET:=Vector2(350,150)
@export var random_pos:=50.0
@export_category("Blurbs")
@export var blurb_chance:=0.25

@export var blurb_cooldown:= 5.0

# Blurbs are loaded from path to save headache
@export var blurbs_path = "res://dialogue/blurbs/"

var blurbs:Array[Dialogue]

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var blurb_timer: Timer = $BlurbTimer

var playing_dialogue:Dialogue
var current_bubble:SpeechBubble

func get_resources_from_path(path: String) -> Array:
	var resources: Array = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..": # Skip "." and ".."
				var file_path = "%s/%s" % [path, file_name]
				if dir.current_is_dir():
					resources += get_resources_from_path(file_path)
				else:
					if ResourceLoader.exists(file_path):
						resources.append(load(file_path))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Could not open directory:", path)
	return resources

func _ready():
	get_blurbs()

func get_blurbs():
	blurbs.clear()
	var banned_blurbs:Array[Dialogue]
	for resource in get_resources_from_path(blurbs_path):
		if resource is Dialogue:
			blurbs.append(resource)
			if resource.follow_up:
				banned_blurbs.append(resource.follow_up)
	for banned_blurb in banned_blurbs:
		blurbs.erase(banned_blurb)

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
