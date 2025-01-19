extends VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func set_text(input: String, response: String):
	
	#### Caret for input text
	var text = " > "
	$Input.text = text + input
	$Input.modulate = Color.mediumpurple
	
	$OutputMessage.text = response



