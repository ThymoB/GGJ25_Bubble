extends Node2D

@export var max_health: float = 100.0
@export var damage_per_clear: float = 20.0
@export var time_to_damage: float = 7.0

@onready var reset_timer: Timer = $ResetTimer
@onready var hide_timer: Timer = $HideTimer

@onready var left_wing: Node2D = $LeftWing
@onready var right_wing: Node2D = $RightWing


var current_health: float
var nodes_left:Array[BossBubble]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	$ProgressBar.value = current_health
	reset_wings()
	pass # Replace with function body.

func hide_wings():
	left_wing.process_mode = Node.PROCESS_MODE_DISABLED
	left_wing.visible = false
	right_wing.process_mode = Node.PROCESS_MODE_DISABLED
	right_wing.visible = false
	hide_timer.wait_time = 0.5
	hide_timer.one_shot = true
	hide_timer.start()
	hide_timer.timeout.connect(reset_wings)

func reset_wings():
	nodes_left.clear()
	left_wing.process_mode = Node.PROCESS_MODE_INHERIT
	left_wing.visible = true
	right_wing.process_mode = Node.PROCESS_MODE_INHERIT
	right_wing.visible = true
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
	reset_timer.wait_time = time_to_damage
	reset_timer.one_shot = true
	reset_timer.start()
	reset_timer.timeout.connect(hide_wings)

func check_wings_down(bubble:BossBubble):
	bubble.boss_bubble_popped_signal.disconnect(check_wings_down)
	nodes_left.remove_at(nodes_left.find(bubble))
	if nodes_left.size() <= 0:
		current_health -= damage_per_clear
		$ProgressBar.value = current_health
		reset_wings()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
