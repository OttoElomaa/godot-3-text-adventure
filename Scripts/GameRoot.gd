extends Control


var starting_room = null
#get_node("ZoneHandler/Zone/Room")
var current_zone = null
var current_room = null

onready var player = $Inventory
onready var command_parser = $CommandParser
onready var text_window = $MainPanel/MarginContainer/Horizontal/TextWindow


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	current_zone = $Zone
	starting_room = current_zone.first_room
	#### JUST TO DEBUG: GO TO DIFF ROOM
	#starting_room = current_zone.antechamber
	
	command_parser.setup(starting_room, $Inventory)
	
	
	current_zone.setup()	
	
	#### Get ZONE, child of zone HANDLER -> not anymore bucko
	#### I reckoned, Zone is just abstraction of some Rooms -> same as ZoneHandler would be
	
	hide_combat_screen()
	
	var test_name = starting_room.room_name
	
	#### Custom SETUP functions
	text_window.setup()
	text_window.start_game( starting_room )
	
	
	
func hide_main_panel():
	
	$MainPanel/MarginContainer/Horizontal.hide()
	
	
func display_combat_screen():
	
	hide_main_panel()
	$MainPanel/MarginContainer/CombatScreen.show()
	
	
func hide_combat_screen():
	
	$MainPanel/MarginContainer/Horizontal.show()
	$MainPanel/MarginContainer/CombatScreen.hide()
	$CommandParser.game_state = Types.GameStates.EXPLORE
	
	$MainPanel/MarginContainer/CombatScreen
	
	
	
	
	
	
	
	
	
	
	


