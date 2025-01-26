extends Node

class_name BubbleManager

signal bubble_popped_signal(bubble:Bubble)

const BUBBLE_SCENE = preload("res://Assets/Bubbles/Bubble.tscn")

@export var bubble_types: Array = [
	{"scene": preload("res://Assets/Bubbles/Bubble.tscn"), "chance": 75.0,"act":0},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Flower/flower_bubble.tscn"), "chance": 10.0,"act":1},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Duck/duck_bubble.tscn"), "chance": 5.0,"act":3},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Scared/scared_bubble.tscn"), "chance": 5.0,"act":3},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Pirate/pirate_bubble.tscn"), "chance": 5.0,"act":2},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Leaf/leaf_bubble.tscn"), "chance": 8.0,"act":1},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Cat/cat_bubble.tscn"), "chance": 5.0,"act":2},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Corn/popcorn_bubble.tscn"), "chance": 5.0,"act":1},
	{"scene": preload("res://Assets/Bubbles/BubbleVariations/Disco/disco_bubble.tscn"), "chance": 5.0,"act":3},
	]
	
@export var bubble_spacing:=75
@export var row_size:=6
@export var base_speed := 5
@export var scroll_speed := 5
@export var max_speed := 40

@onready var bubble_root: Node2D = $Center
@onready var background: Sprite2D = $Background

var bubbles:Array[Bubble]
var bubbles_popped:=0

var bubbles_begin_index_y := 0
var bubbles_end_index_y := 0

func index_bubbles(x: int, y: int) -> Bubble:
	return bubbles[(y - bubbles_begin_index_y) * row_size + x]

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
		if item["act"] == GameManager.get_current_act() or item["act"]==0:
			total_weight += item["chance"]

	# Generate a random number within the total weight range
	var random_value = randf() * total_weight
	var cumulative_weight = 0
	
	# Iterate over the scenes and select one based on the random value
	for item in bubble_types:
		if item["act"] == GameManager.get_current_act() or item["act"]==0:
			cumulative_weight += item["chance"]
			if random_value < cumulative_weight:
				return item["scene"]
	
	# Fallback (should never hit this if data is correctly configured)
	return bubble_types[0]["scene"]

func _ready() -> void:
	instance = self
	#bubble_root the bubble_root in the middle of the screen
	bubble_root.position.x = get_viewport().size.x*0.5

	# hack for web build
	background.position.x = get_viewport().size.x*0.5
	GameManager.on_bubble_manager_created.emit(self)
	spawn_bubbles()
	
func _process(delta: float) -> void:
	despawn_offscreen()
	spawn_bubbles()
	decay_heat(delta)
	update_speed()
	seconds_since_pop += delta
	#move bubbles and wrap
	bubble_root.position += Vector2(0,delta*-scroll_speed)

func update_speed():
	var num_popped = 0
	for bubble in bubbles:
		if bubble.is_popped():
			num_popped += 1

	var precent_popped = float(num_popped) / float(bubbles.size())
	scroll_speed = lerp(base_speed, max_speed, precent_popped)

func spawn_bubbles():
	var top_left_pos = bubble_root.global_position - Vector2(bubble_spacing * row_size / 2.0, 0)
	var viewport_height = get_viewport().size.y
	var bottom_y = -top_left_pos.y + viewport_height

	#index of the bottom of the screen
	var bottom_index = bottom_y / bubble_spacing

	while (bottom_index > bubbles_end_index_y):
		bubbles_end_index_y += 1
		for i in range(0, row_size):
			spawn_bubble(i, bubbles_end_index_y)

func despawn_offscreen():
	var top_left_pos = bubble_root.global_position - Vector2(bubble_spacing * row_size / 2.0, 0)

	while !bubbles.is_empty() && (bubbles[0].index_y * bubble_spacing + top_left_pos.y) < -bubble_spacing:
		bubbles[0].queue_free()
		bubbles.pop_front()

func spawn_bubble(index_x: int, index_y: int):
	var top_left_pos = bubble_root.global_position - Vector2(bubble_spacing * row_size / 2.0, 0)
	var selected_bubble = pick_random_bubble()
	var new_bubble = selected_bubble.instantiate()
	bubble_root.add_child(new_bubble)
	
	var pos:Vector2
	pos.x = top_left_pos.x + index_x * bubble_spacing
	pos.y = bubble_root.global_position.y + index_y * bubble_spacing
	pos.x += index_y % 2 * bubble_spacing / 2.0

	new_bubble.index_x = index_x
	new_bubble.index_y = index_y
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
