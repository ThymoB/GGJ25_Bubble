extends Node

class_name BubbleManager

const BUBBLE_SCENE = preload("res://Assets/Bubbles/Bubble.tscn")

@export var bubbles_to_spawn:=100
@export var bubble_spacing:=75
@export var row_size:=6

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

func _ready() -> void:
	spawn_bubbles()
	
func _process(delta: float) -> void:
	decay_heat(delta)
	seconds_since_pop += delta

func spawn_bubbles():
	var top_left_pos = center.global_position - Vector2(bubble_spacing * row_size / 2.0, 0)
	for i in range(bubbles_to_spawn):
		var new_bubble = BUBBLE_SCENE.instantiate()
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
	add_heat()
	seconds_since_pop = 0.0 
	pass
	
func add_heat():
	heat = minf(HEAT_MAX, heat + HEAT_PER_POP)
	pass
	
func decay_heat(dt: float):
	heat = maxf(0.0, heat - HEAT_DECAY_PER_SEC * dt)
	pass
	
