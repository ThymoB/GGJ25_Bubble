extends Node

class_name BubbleManager

signal bubble_popped_signal(bubble:Bubble)

const BUBBLE_SCENE = preload("res://Assets/Bubbles/Bubble.tscn")

@export var bubble_types: Array = [
	{"scene": preload("res://Assets/Bubbles/Bubble.tscn"), "chance": 75.0},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Bomb/bomb_bubble.tscn"), "chance": 10.0},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Duck/duck_bubble.tscn"), "chance": 5.0},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Scared/scared_bubble.tscn"), "chance": 5.0},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Pirate/pirate_bubble.tscn"), "chance": 5.0}]
	
@export var bubbles_to_spawn:=100
@export var bubble_spacing:=75
@export var row_size:=6
@export var scroll_speed = 10

@onready var center: Node2D = $Center

var bubbles:Array[Bubble]
var bubbles_popped:=0

# Heat is built up by popping bubbles and decays linearly over time,
# use it for informing gameplay events which depend on how fast bubbles are
# being popped.
var heat := 0.0
const HEAT_MAX := 1.0
const HEAT_PER_POP := 0.2;
const HEAT_DECAY_PER_SEC := 0.1

var seconds_since_pop = 0.0

static var instance:BubbleManager

func pick_random_bubble() -> PackedScene:
	var total_weight = 0
	
	# Calculate the total weight
	for item in bubble_types:
		total_weight += item["chance"]
	
	# Generate a random number within the total weight range
	var random_value = randf() * total_weight
	var cumulative_weight = 0
	
	# Iterate over the scenes and select one based on the random value
	for item in bubble_types:
		cumulative_weight += item["chance"]
		if random_value < cumulative_weight:
			return item["scene"]
	
	# Fallback (should never hit this if data is correctly configured)
	return bubble_types[0]["scene"]

func _ready() -> void:
	instance = self
	GameManager.on_bubble_manager_created.emit(self)
	spawn_bubbles()
	
func _process(delta: float) -> void:
	decay_heat(delta)
	seconds_since_pop += delta
	#move bubbles and wrap
	center.position += Vector2(0,delta*-scroll_speed)

func spawn_bubbles():
	var top_left_pos = center.global_position - Vector2(bubble_spacing * row_size / 2.0, 0)
	for i in range(bubbles_to_spawn):
		var selected_bubble = pick_random_bubble()
		var new_bubble = selected_bubble.instantiate()
		center.add_child(new_bubble)
		var pos:Vector2
		pos.x = top_left_pos.x + (i % row_size) * bubble_spacing
		pos.y = center.global_position.y + floori(i / float(row_size)) * bubble_spacing
		@warning_ignore("integer_division")
		pos.x += (i / row_size) % 2 * bubble_spacing / 2.0
		new_bubble.global_position = pos
		new_bubble.bubble_manager = self
		bubbles.append(new_bubble)

# Do cool stuff here
# You can check bubbles_popped to see how many bubbles have been popped
func on_bubble_popped(bubble:Bubble):
	bubble_popped_signal.emit(bubble)
	add_heat()
	seconds_since_pop = 0.0 
	try_trigger_dialogue()
	
func add_heat():
	heat = minf(HEAT_MAX, heat + HEAT_PER_POP)
	
func decay_heat(dt: float):
	heat = maxf(0.0, heat - HEAT_DECAY_PER_SEC * dt)

func try_trigger_dialogue():
	DialogueManager.try_play_blurb()
