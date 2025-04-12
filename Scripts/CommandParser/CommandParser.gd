extends Node


const OutputMessage = preload("res://Scenes/OutputMessage.tscn")

var game_root = null
var visual_panel = null
var text_window = null

onready var dialogue = $Dialogue
onready var exploration = $Exploration
onready var event_node = $Event


var game_state = null
var game_situation = null

var player = null

var current_zone = null
var current_room = null
var current_dialogue_npc = null
var current_container = null

var previous_room = null

var first_word := ""
var second_word := ""

var white_c := Color.white
var yellow_c := Color.burlywood
var green_c := Color.lightgreen


enum Situations {
	
	NONE, CONTAINER,
}





#### This is CALLED Where??
#### In GameRoot, now
func setup(starting_room, player):
	
	
	game_root = DataScene.get_game_root()
	visual_panel = DataScene.get_visual_panel()
	text_window = DataScene.get_text_window()
	
	self.player = player
	current_room = starting_room
	current_zone = game_root.current_zone
	
	for node in get_children():
		if node.has_method("setup"):
			node.setup(self)
	
	#change_room(current_room)
	
	var game_root = get_tree().root.get_node("GameRoot")
	
	
	game_state = Types.GameStates.EXPLORE
	
	var test_name = starting_room.room_name
	
	print("Setup done!")


	
###################################################################################################	

func split_word(input: String):
	
	#### Delineator, allow_false, max split
	var words = input.split(" ",false)
	if words[0] in ["show","display"]:
		words.remove(0)
	
	
	#### ERROR
	if words.size() == 0:
		return "Deez nuts"
		
	#### PARSE FIRST WORD
	first_word = words[0].to_lower()
	words = split_multi_word_help(words)
	
	#### PARSE SECOND
	if words.size() >= 2:
		second_word = words[1].to_lower()



func split_multi_word_help(words: Array) -> Array:
	#### FOR DEALING WITH 3+ WORDS
	#if words.size() <= 2:
		#return words
	
	
	
	for i in range(words.size() - 1):
		if words[i] in ["up","in","on","to",
		"from","the","a"]:
			words.remove(i)

	return words


func process_command( input:String ) -> String:
	
	var response = ""
	
	#### RESET the 2 input words
	first_word = ""
	second_word = ""
	
	split_word(input)
	
	#### PROCEED USING THE CORRECT INPUT STATE
	match game_state:
		
		Types.GameStates.EXPLORE:
			
			response = exploration.process_command_explore(input)
			
		Types.GameStates.DIALOGUE:
			
			response = dialogue.process_command_dialogue(input)
			
		Types.GameStates.COMBAT:
			
			response = process_command_combat(input)
			
		Types.GameStates.EVENT:
			
			response = event_node.process_command_event(input)
			
	return response
		
	
	
	

func process_command_combat(input):

	return "It's combat time"

	





func get_right_item_list():
	
	if game_situation == Situations.CONTAINER:
		return current_container.get_children()
	return current_room.get_items()




func forget_current_container():
	game_situation = Situations.NONE
	current_container = null



	

func look_for_item_in_list(item_list, item_id: String) -> Node:
	
	var nums = ["1","2","3","4","5","6","7","8","9",10,11,12,13,14,15,16,17,18,19,20]
	var item = null
	
	if item_list.size() <= 0:
		return null
	
	#### Get ITEM by its NUMBER in list (inventory for example)
	if item_id in nums:
			
		var num = int(second_word)
		if item_list.size() >= num:
			item = item_list[num - 1]
	
	#### Get ITEM by BROWSING the list (inventory etc)		
	for item2 in item_list:
		if second_word.to_lower() == item2.item_id.to_lower():
			item = item2
				
	return item
	
	
	




		
#### SET the provided Room as CURRENT room, provide flavor TEXT	
func change_room(new_room) -> String:
	
	#### 1: CHANGE ZONE here too? Alternate to normal: call change_room on new zone's room	
	if new_room.type == Types.RoomTypes.ZONE_SWITCH:
		
		#### GET ZONE -FUNCTION
		var new_zone = game_root.get_zone(new_room.switch_to_zone)
		var new_start_room = new_zone.get_room(new_room.switch_to_room)
		
		var switch_message = "You travel from %s to %s!" % [current_zone.zone_name, new_zone.zone_name]
		text_window.handle_adding_message(switch_message, Color.lightgreen)
		
		current_zone = new_zone
		change_room(new_start_room)
	
	
	#### 2: Called in BASIC rooms and AFTER room switch (the If above)
	else:
		change_room_two(new_room)
		return ""
		
	return ""



func change_room_two(new_room):
	
	
	forget_current_container()
	
	#### SAVE PREV ROOM FOR RETREATING
	previous_room = current_room
	
	current_room = new_room
	var zone = current_zone
	#DataScene.get_command_parser().current_zone
	
	var visual_panel = DataScene.get_visual_panel()
	visual_panel.set_room_label(current_room.room_name)
	visual_panel.set_zone_label("in " + zone.zone_name)
	visual_panel.build_zonemap(current_room)
	visual_panel.change_room_icon(zone)
	
	
	var items_list = current_room.get_items()
	visual_panel.set_exits_list(current_room.exits, current_room)
	visual_panel.set_items_list(items_list, null)
	
	
	if new_room.has_combat:
		game_state = Types.GameStates.EVENT
	
	#################################
	#### TEXT WINDOW PRINTOUT
	var change_string = current_room.create_room_description()
	text_window.handle_adding_message(change_string, Color.white)
	
	#### NPC INFO
	var npc_text = current_room.create_npc_description()
	if npc_text != "":
		text_window.handle_adding_message(npc_text, Color.lightgreen)

	#### COMBAT INFO
	var encounter_text = current_room.create_encounter_description()
	if encounter_text != "":
		text_window.handle_adding_message(encounter_text, Color.lightcoral)



func debug_go_to_zone_and_room(zone:Node, room:Node):
	
	current_zone = zone
	change_room(room)



#### CREATE a PoolStringArray
func create_pool_string(array: Array, delienator: String):
	
	return PoolStringArray( array ) .join(delienator)






