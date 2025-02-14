extends Node2D

class_name Hand
@onready var animation_player: AnimationPlayer = $Scaler/Hand_Sprite2D/AnimationPlayer

@export var hand_speed = 350.0
static var instance:Hand
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	instance = self

var mouse_position = Vector2.ZERO
var target_delta =  Vector2.ZERO
var weight = 0.0
var length_factor = 0.0
var lerped_hand_speed = 0.0
	
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
	
func _physics_process(_delta: float) -> void:	
	#press down
	if Input.is_action_just_pressed("click"):
		#reset anim if already playing
		if animation_player.is_playing():
			animation_player.stop()
		animation_player.play("Scale_Hand")
		#detect bubbles underneath finger and pop
		var overlapping_areas = $HandCollision_Area2D.get_overlapping_areas()
		for area in overlapping_areas:
			var overlap_bubble = area.get_parent()
			if overlap_bubble as Bubble:
				overlap_bubble.pop()
			if overlap_bubble as SpeechBubble:
				overlap_bubble.close_dialogue()
