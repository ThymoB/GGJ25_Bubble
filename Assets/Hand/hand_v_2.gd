extends Node2D
var mouse_position = Vector2.ZERO
var target_delta =  Vector2.ZERO
var weight = 0.0
var length_factor = 0.0
var lerped_hand_speed
@onready var animation_player: AnimationPlayer = $Scaler/Hand_Sprite2D/AnimationPlayer

@export var hand_speed = 350.0
#unc interpolateVector()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#mouse control. Move hand towards mouse position. smooth out the last bit 
	#get mouse position, interpolate hand to that position
	mouse_position = get_viewport().get_mouse_position()
	target_delta = mouse_position - global_position
	length_factor = target_delta.length()/50
	weight = clamp(length_factor,0,1)
	lerped_hand_speed = lerp((hand_speed*0.1), hand_speed,weight)
	global_position = global_position + target_delta.normalized() * lerped_hand_speed * delta
	
func _physics_process(delta: float) -> void:	
	
	#press down
	if Input.is_action_just_pressed("click"):
		#reset anim if already playing
		if animation_player.is_playing():
			animation_player.stop()
		animation_player.play("Scale_Hand")
		#detect bubbles underneath finger and pop
		var overlapping_areas = $HandCollision_Area2D.get_overlapping_areas()
		for area in overlapping_areas:
			#print("Overlapping with:", area.name)
			var overlap_bubble = area.get_parent()
			if overlap_bubble as Bubble:
				overlap_bubble.pop()
		




"""
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area:
		if area.get_parent() as Bubble:
			print("i entered bubble")
"""

"""
func detect_collision_at_point(position: Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, position)
	var result = space_state.intersect_point(query)
	
	for item in result:
		if not item.collider.is_null():
			print("Collision detected with: ", item.collider.name)
""" 
