extends Node

class_name BubbleManager

const BUBBLE_SCENE = preload("res://Assets/Bubbles/Bubble.tscn")

@export var bubbles_to_spawn:=100
@export var bubble_spacing:=75
@export var row_size:=6

@onready var center: Node2D = $Center

var bubbles_popped:=0

func _ready() -> void:
	spawn_bubbles()

func spawn_bubbles():
	var top_left_pos = center.global_position - Vector2(bubble_spacing * row_size / 2, 0)
	for i in range(bubbles_to_spawn):
		var new_bubble = BUBBLE_SCENE.instantiate()
		center.add_child(new_bubble)
		var pos:Vector2
		pos.x = top_left_pos.x + (i % row_size) * bubble_spacing
		pos.y = center.global_position.y + floori(i / row_size) * bubble_spacing
		pos.x += (i / row_size) % 2 * bubble_spacing / 2
		new_bubble.global_position = pos
		new_bubble.bubble_manager = self

func pop_bubble(bubble:Bubble):
	bubble.queue_free()
	bubbles_popped += 1
	print("Bubbles popped: " + str(bubbles_popped))
	
