extends LineEdit





# Called when the node enters the scene tree for the first time.
func _ready():
	
	grab_focus()


#### CLEAR the input line.
func _on_InputLine_text_entered(new_text):
	
	clear()
