extends Button
@onready var button_arm_1: Button = $"../Button_Arm1"
@onready var button_arm_2: Button = $"../Button_Arm2"
@onready var button_arm_3: Button = $"../Button_Arm3"
@onready var button_arm_4: Button = $"../Button_Arm4"


func _on_pressed() -> void:
	button_arm_1.button_pressed = false
	button_arm_2.button_pressed = false
	button_arm_3.button_pressed = false
	button_arm_4.button_pressed = false
	self.button_pressed = true
	match self:
		button_arm_1:
			HandSkinManager.selected_arm_skin = 0
		button_arm_2:
			HandSkinManager.selected_arm_skin = 1
		button_arm_3:
			HandSkinManager.selected_arm_skin = 2
		button_arm_4:
			HandSkinManager.selected_arm_skin = 3
