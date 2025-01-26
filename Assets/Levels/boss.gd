extends Node2D

@export var max_health: float = 100.0
var current_health: float
var nodes_left:Array[BossBubble]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	$ProgressBar.value = current_health
	reset_wings()
	pass # Replace with function body.

func reset_wings():
	for left_node in $LeftWing.get_children():
		var left_bubble = left_node as BossBubble 
		left_bubble.unpop()
		left_bubble.boss_bubble_popped_signal.connect(check_wings_down)
		nodes_left.append(left_bubble)
	for right_node in $RightWing.get_children():
		var right_bubble = right_node as BossBubble 
		right_bubble.unpop()
		right_bubble.boss_bubble_popped_signal.connect(check_wings_down)
		nodes_left.append(right_bubble)

func check_wings_down(bubble:BossBubble):
	bubble.boss_bubble_popped_signal.disconnect(check_wings_down)
	nodes_left.remove_at(nodes_left.find(bubble))
	if nodes_left.size() <= 0:
		current_health -= 10.0
		$ProgressBar.value = current_health
		reset_wings()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
