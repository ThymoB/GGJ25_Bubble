extends Node

class_name BubbleManager

const BUBBLE_SCENE = preload("res://Assets/Bubbles/Bubble.tscn")

@export var bubbles_to_spawn:=100
@export var bubble_spacing:=75
@export var row_size:=6

@onready var corner: Node2D = $SpriteWrap/corner

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
	var top_left_pos = corner.global_position
	for i in range(bubbles_to_spawn):
		var index_x = i % row_size
		@warning_ignore("integer_division")
		var index_y = i / row_size
		
		var new_bubble = BUBBLE_SCENE.instantiate()
		new_bubble.index_x = index_x
		new_bubble.index_y = index_y
		new_bubble.bubble_manager = self
		
		corner.add_child(new_bubble)
		
		var pos:Vector2
		pos.x = top_left_pos.x + index_x * bubble_spacing
		pos.y = corner.global_position.y + index_y * bubble_spacing
		pos.x += index_y % 2 * bubble_spacing / 2.0
		new_bubble.global_position = pos

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
	
