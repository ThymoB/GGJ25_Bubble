extends Node

const BUBBLE_SCENE = preload("res://Assets/Bubbles/Bubble.tscn")

@export var bubbles_to_spawn:=100
@export var bubble_spacing:=50
@export var row_size:=10

@onready var center: Node2D = $Center

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
		new_bubble.global_position = pos
		
