extends VBoxContainer

#### CONSTS - nodes to create
const Row = preload("res://Scenes/Row.tscn")
const OutputMessage = preload("res://Scenes/OutputMessage.tscn")

#### Stuff OUTSIDE this scene
#onready var visual_panel = get_parent().get_node("VisualPanel")

#### Stuff INSIDE this scene
onready var history_rows = $InfoPanel/Margins/Scroll/HistoryRows
#onready var command_parser = get_tree().root.get_node("CommandParser")

#### Editable EXPORT values
export (int) var max_rows = 100


var visual_panel = null
var command_parser = null


onready var scroll = $InfoPanel/Margins/Scroll
onready var scroll_bar = scroll.get_v_scrollbar()

var max_scroll := 0



###################################################################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	
	scroll_bar.connect("changed",self,"handle_scrollbar_changed")
	max_scroll = scroll_bar.max_value
	
	
	
func setup():
	
	visual_panel = get_parent().get_node("VisualPanel")
	command_parser = get_tree().root.get_node("GameRoot/CommandParser")
	
	print("Setup done!")
	
	#### SIGNAL for message info
	#command_parser.connect("message_generated",self,"handle_adding_message")
	
	
#### CALLED in GameRoot
func start_game( starting_room):
	
	var start_game_message = create_game_start_message()
	handle_adding_message(start_game_message, Color.white)
	
	#var room = command_parser.current_room
	var starting_room_string = command_parser.change_room(starting_room)
	handle_adding_message(starting_room_string, Color.white)


#### Called at the very START of the GAME.
func create_game_start_message():
	
	var message_text = "Welcome to the text adventure! You wake up in a room, inside a house."
	message_text += "You know not why you are there. Try 'help'."
	
	return message_text


func handle_scrollbar_changed():
	
	if max_scroll != scroll_bar.max_value:
		
		max_scroll = scroll_bar.max_value
		scroll.scroll_vertical = max_scroll


##############################################################
#### INPUT STUFF

#### Ran when NEW INPUT is entered
func _on_InputLine_text_entered(new_text):
	
	#### Prevent EMPTY inputs
	if new_text.empty():
		return
	
	var response = command_parser.process_command(new_text)
	if response.empty():
		return
	
	#### Create ROW element
	var row = Row.instance()
	row.set_text(new_text, response)
	
	add_output_message(row)


#### USE CASE: When printing input-output rows in UNUSUAL places -> outside _inputline_text_entered()
func create_custom_row(new_text, response):
	
	#### Create ROW element
	var row = Row.instance()
	row.set_text(new_text, response)
	
	#### CUSTOM SHIT to create rows with only the input text, not response
	if response == "":
		row.get_node("OutputMessage").queue_free()
	
	add_output_message(row)


#### Use: Generating simple OUTPUT messages without an accompanying INPUT row.
func handle_adding_message(message_text: String, color: Color):
	
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
	
	
