extends Node

@warning_ignore("unused_signal")
signal on_bubble_manager_created(bubble_manager:BubbleManager)

# After this amount, go to the next Act
@export var act_pop_thresholds:=[
	25,
	50,
	75,
	100,
]

func get_current_act()->int:
	var act:=1
	for threshold in act_pop_thresholds:
		if BubbleManager.instance.bubbles_popped >= threshold:
			act += 1
	return act

func _process(delta: float):
	if !BubbleManager || !BubbleManager.instance:
		return

	if get_current_act() >= 4:
		get_tree().change_scene_to_file("res://Assets/Levels/BossTransition.tscn")
