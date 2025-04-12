extends Node



var current_room:Node = null
var parser:Node = null
var game_root:Node = null
var text_window:Node = null



func setup(parser):
	
	self.parser = parser
	#current_dialogue_npc = parser.current_dialogue_npc
	#player = parser.player
	
	#visual_panel = parser.visual_panel
	text_window = parser.text_window
	game_root = parser.game_root




func process_command_event(input):
	
	#parser = get_parent()
	current_room = parser.current_room
	
	match input:
		
		"fight", "f":
			return fight()
			
		"run", "retreat", "r":
			return retreat(input)
	
	return "You're in an Event! Your actions have been restricted!"




func fight():
	
	var combat_screen = DataScene.get_combat_screen()
	
	if current_room.has_combat:
		
		game_root.display_combat_screen()
		parser.game_state = Types.GameStates.COMBAT
		combat_screen.setup_and_fight(current_room)
		
		return "Combat initiated!"
		
	else:
		return "No combat encounter in this room!"


func retreat(input):
	
	var previous_room:Node = parser.previous_room
	
	text_window.create_custom_row(input, "You run back to %s!" % previous_room.room_name)
	parser.game_state = Types.GameStates.EXPLORE
	return parser.change_room(previous_room)
