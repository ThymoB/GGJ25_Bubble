extends Node2D

class_name SpeechBubble

@onready var title: RichTextLabel = $Title
@onready var body: RichTextLabel = $Body

@onready var lifetime: Timer = $Lifetime

var dialogue:Dialogue

func populate(in_dialogue:Dialogue):
	dialogue = in_dialogue
	title.text = dialogue.character
	body.text = dialogue.line

func close_dialogue():
	DialogueManager.stop_current_dialogue()

func _on_lifetime_timeout() -> void:
	if DialogueManager.current_bubble == self:
		close_dialogue()
