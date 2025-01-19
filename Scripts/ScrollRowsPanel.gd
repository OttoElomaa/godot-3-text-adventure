extends PanelContainer


#### CONSTS - nodes to create
const OutputMessage = preload("res://Scenes/OutputMessage.tscn")

#### Stuff OUTSIDE this scene
#onready var visual_panel = get_parent().get_node("VisualPanel")

#### Stuff INSIDE this scene
onready var history_rows = $MarginContainer/ScrollCont/Rows
#onready var command_parser = get_tree().root.get_node("CommandParser")

#### Editable EXPORT values
export (int) var max_rows = 100


var visual_panel = null
var command_parser = null


onready var scroll = $MarginContainer/ScrollCont
onready var scroll_bar = scroll.get_v_scrollbar()

var max_scroll := 0



###################################################################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	
	scroll_bar.connect("changed",self,"handle_scrollbar_changed")
	max_scroll = scroll_bar.max_value
	scroll.set_v_scroll(55)
	scroll.update()
	
	
func _on_ScrollRowsPanel_mouse_entered():
	
	#hide()
	scroll.grab_focus()
	
	
func handle_scrollbar_changed():
	
	if max_scroll != scroll_bar.max_value:
		
		max_scroll = scroll_bar.max_value
		scroll.scroll_vertical = max_scroll


#### INPUT STUFF

#### Use: Generating simple OUTPUT messages without an accompanying INPUT row.
func handle_adding_message(message_text: String, color):
	
	var message = OutputMessage.instance()
	message.text = message_text 
	message.modulate = color
	
	add_output_message(message)
	

#func add_general_message(output_message: Control):
	#pass

func add_output_message(row: Control):
	
	history_rows.add_child(row)
	delete_excess_history()

	
	
#### REMOVES extra lines beyond max_rows value.	
func delete_excess_history():	
	
	var rows_count = history_rows.get_child_count()
	if rows_count > max_rows:
		
		var rows_to_forget = rows_count - max_rows
		for i in range(rows_to_forget):
			history_rows.get_child(i).queue_free()
			
			
func wipe_history():
	
	var rows_to_forget = $MarginContainer/ScrollCont/Rows.get_child_count()
	for i in range(rows_to_forget):
		history_rows.get_child(i).queue_free()
	
	
	




