extends Node

# After this amount, go to the next Act
@export var act_pop_thresholds:=[
	25,
	50,
	75
]

func get_current_act()->int:
	var act:=1
	for threshold in act_pop_thresholds:
		if BubbleManager.instance.bubbles_popped >= threshold:
			act += 1
	return act
