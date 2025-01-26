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
	var play_follow_up := dialogue.follow_up and DialogueManager.current_bubble and DialogueManager.current_bubble.dialogue == self
	DialogueManager.stop_current_dialogue()
	if play_follow_up:
		DialogueManager.play_dialogue(dialogue.follow_up)

func _on_lifetime_timeout() -> void:
	if DialogueManager.current_bubble == self:
		close_dialogue()
