extends Resource

class_name Dialogue

@export var unique_to_act:=true
@export var act:=1
@export var character:String
@export var line: String
@export var audio_clip:AudioStream

@export var follow_up:Dialogue

# Virtual function to add on triggered effects to child classes
func on_triggered():
	pass
