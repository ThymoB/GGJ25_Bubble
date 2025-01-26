extends Bubble


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("Disco")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pop():
	$AnimatedSprite2D.visible = false
	$Sprite.visible = true
	super()
