extends Node


const OutputMessage = preload("res://Scenes/OutputMessage.tscn")

var game_root = null
var visual_panel = null
var text_window = null

var game_state = null
var game_situation = null

var player = null

var current_zone = null
var current_room = null
var current_dialogue_npc = null
var current_container = null

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
	#change_room(current_room)
	
	var game_root = get_tree().root.get_node("GameRoot")
	current_zone = game_root.get_node("Zone") 
	
	game_state = Types.GameStates.EXPLORE
	
	var test_name = starting_room.room_name
	
	print("Setup done!")


	
###################################################################################################	

func split_word(input):
	
	#### Delineator, allow_false, max split
	var words = input.split(" ",false)
	
	#### ERROR
	if words.size() == 0:
		return "Deez nuts"
	
	first_word = words[0].to_lower()
	second_word = ""
	
	if words.size() >= 2:
		second_word = words[1].to_lower()



func process_command( input:String ) -> String:
	
	var response = ""
	
	#### RESET the 2 input words
	first_word = ""
	second_word = ""
	
	match game_state:
		
		Types.GameStates.EXPLORE:
			
			response = process_command_explore(input)
			
		Types.GameStates.DIALOGUE:
			
			response = process_command_dialogue(input)
			
		Types.GameStates.COMBAT:
			
			response = process_command_combat(input)
			
	return response
		
	
	
	

func process_command_explore(input):
	
	var response = ""
	
	split_word(input)
	
	
	if not first_word in ["help", "h"]:
		visual_panel.hide_help()
	
	match first_word:
		
		"go", "walk", "w":
			response = go(input, second_word)
			
		"hail", "h", "speak", "talk",  "salute", "s":
			return hail(first_word)
		
		"fight", "f":
			return fight()
				
		"take", "t", "get", "g":
			return take(second_word)
			
		"use", "u":
			return use(second_word)
			
		"drop", "d":
			return drop(second_word)
		
		"open":
			return open(second_word)
			
		"help":
			response = help()
			
		"hide":
			
			response = hide()
			
		
			
		"inventory", "inv":
			return inventory()	
			
	return response 



func process_command_dialogue(input: String) -> String:
	
	
	var first_name = current_dialogue_npc.npc_name.split(" ")[0]
	
	split_word(input)
	
	match first_word:
		
	###############################
		#### UNIVERSAL KEYWORDS
		"end", "bye", "goodbye":
			
			game_state = Types.GameStates.EXPLORE
			current_dialogue_npc = null
			visual_panel.hide_alt_panel()
			text_window.create_custom_row(input, "You end the conversation.")
			return ""
		
		
		"you":
			return first_name + ": 'My name is " + current_dialogue_npc.npc_name + ".'"
			
		"me":
			return first_name + ": 'I don't know who you are.'"
		
		"give":
			
			give(input, second_word)
			
			return ""
			
		"grant":
			
			if current_dialogue_npc.can_receive:
				text_window.create_custom_row(input, first_name + ": I can't Grant you an item unless you Give something in return.")
				text_window.handle_adding_message(current_dialogue_npc.give_dialogue, white_c)
				
			elif current_dialogue_npc.can_grant:
				text_window.create_custom_row(input, first_name + ": Yes, I can give you an item.")
				
			else:
				text_window.create_custom_row(input, first_name + ": Sorry, I have nothing to Grant you.")
			return ""
	
	####################################
		#### TOPIC SYSTEM KEYWORDS	
		_:
			
			var word_found = false
			var npc_word1 = ""
			
			#### YOU DON'T KNOW THIS WORD
			if not input in DataScene.known_keywords:
				text_window.create_custom_row(input, "That keyword is unknown to you.")
				return ""
			
			
			#### Get RESPONSE using TOPIC resource
			for npc_word in get_npc_keywords():
				
				if input == npc_word:
					word_found = true
					npc_word1 = npc_word
			
			
			#### YOU and the NPC Both KNOW the word			
			if word_found:
				
				text_window.create_custom_row(input, "")
				
				var topic_path = DataScene.get_topic_resource(input)
				var topic = load(topic_path)
				
				#### Print TOPIC TEXT
				var response = "%s: '%s' \n" % [first_name, topic.topic_text]
				text_window.handle_adding_message(response, white_c)
				
				#### KEYWORDS included and new words LEARNED
				response = "Keywords: %s" % topic.topic_keywords
				text_window.handle_adding_message(response, yellow_c)
				
				for word in get_topic_keywords(topic):
					
					if not word in DataScene.known_keywords:
						
						DataScene.known_keywords.append(word)
						text_window.handle_adding_message("You learn a new topic: %s." % word, green_c)
						
				display_keywords()
				return ""
				
			else:
				text_window.create_custom_row(input, first_name + ": 'I'm sorry, I know nothing about that.'")
				return ""
					
	return "Among us"


func give(input, second_word):
	
	var inv = player.get_inventory()
	var item = null
	var npc = current_dialogue_npc
	var first_name = npc.npc_name.split(" ")[0]
	
	if npc.can_receive and npc.can_grant:
		
		match second_word:		
			"":
				text_window.create_custom_row(input, first_name + ": Yes, I need an item. Can you Give it to me?")
				text_window.handle_adding_message(current_dialogue_npc.give_dialogue, white_c)
				text_window.handle_adding_message("They want this item: " + current_dialogue_npc.receive_item_id, yellow_c)
		
			current_dialogue_npc.receive_item_id:
				item = look_for_item_in_list(inv, second_word)
				if item == null:
					text_window.create_custom_row(input, "Yes, that's the item. You don't have it, though.")
				
				else:
					text_window.create_custom_row(input, first_name + ": You have the item I want!")
					text_window.handle_adding_message(current_dialogue_npc.post_quest_dialogue, white_c)
					
					text_window.handle_adding_message("You give the " + item.item_name + " away!", yellow_c)
					player.remove_from_inventory(item)
					
					var grant_item = DataScene.get_file_reader().get_item_by_id(npc.grant_item_id)
					player.put_in_inventory(grant_item)
			_:
				text_window.create_custom_row(input, "I don't need that kind of item.")
			
	else:
		text_window.create_custom_row(input, first_name + ": No, I don't need anything you can Give me.")
	
	
func grant(second_word):
	pass


func handle_keyword_system():
	pass


func process_command_combat(input):

	return "It's combat time"

	
func go(input, second_word: String) -> String:
	
	#### ALLOW redirects from shorthands
	match second_word:
		"s":
			second_word = "south"
		"n":
			second_word = "north"
		"e":
			second_word = "east"
		"w":
			second_word = "west"
	
	#### No SECOND word
	if second_word.empty():
		return "Insert second word (direction) to walk."
	
	#### VALID second word	
	elif current_room.exits.keys().has(second_word):
		
		var exit = current_room.exits[second_word]
		
		if exit.check_is_other_room_locked(current_room):
			return "You find the entrance to be locked!"
		else:
			text_window.create_custom_row(input, "You walk %s!" % second_word)
			change_room( exit.get_other_room(current_room) )
			#return PoolStringArray(["You walk %s!" % second_word, new_room_string ]).join("\n")
			#### RESTORE IF BROKE
			return ""
	
	#### INVALID second word	
	else:
		return "Invalid direction to walk."
		

func hail(input) -> String:

	var white_c = Color.white
	var yellow_c = Color.burlywood
	var green_c = Color.lightgreen
		
	var character = current_room.room_character
	var first_name = null
	
	if character == null:
		return "There's nobody here to talk to."
		
	else:
		first_name = character.npc_name
		
		visual_panel.display_alt_panel()
		visual_panel.display_dialogue_screen(current_room)
		game_state = Types.GameStates.DIALOGUE
		current_dialogue_npc = character
		
		display_keywords()
		
		var hail_str = "You hail %s!" % character.npc_name
		text_window.create_custom_row(input, "")
		
		text_window.handle_adding_message(hail_str, green_c)
		
		#### Print GREETING LINE and associated KEYWORDS
		text_window.handle_adding_message("%s: '%s'" % [first_name, character.greeting_line], white_c)
		text_window.handle_adding_message("Keywords: %s" % character.greeting_keywords, yellow_c)
		
		for word in get_npc_greet_keywords(character):
					
			if not word in DataScene.known_keywords:
				
				DataScene.known_keywords.append(word)
				text_window.handle_adding_message("You learn a new topic: %s." % word, green_c)
				
		display_keywords()
		
		return ""

	
func get_npc_keywords():
	
	var keyword_str = current_dialogue_npc.npc_keywords
	return keyword_str.split(",")


func get_topic_keywords(topic):
	
	var keyword_str = topic.topic_keywords
	return keyword_str.split(",")


func get_npc_greet_keywords(npc):
	return npc.greeting_keywords.split(",")


func display_keywords():
	
	visual_panel.wipe_keyword_list()
	
	#### FILL UP keyword list
	for word in DataScene.known_keywords:
		for npc_word in get_npc_keywords():
			
			if word == npc_word:
				#text_window.handle_adding_message("YOOOO " + word)
				visual_panel.populate_keyword_list(word)
	

func fight():
	
	var combat_screen = DataScene.get_combat_screen()
	
	if current_room.has_combat:
		
		game_root.display_combat_screen()
		game_state = Types.GameStates.COMBAT
		combat_screen.setup_and_fight(current_room)
		
		
	
		return "Combat initiated!"
		
	else:
		
		return "No combat encounter in this room!"


func take(second_word: String) -> String:
	
	var nums = ["1","2","3","4","5","6","7","8","9",10,11,12,13,14,15,16,17,18,19,20]
	
	var visual_panel = DataScene.get_visual_panel()
	
	if second_word.empty():
		return "Insert second word (item name) to take."
		
	if current_room.get_items().empty():
		return "No items to take!"
	
	#### LOOK IN CURRENT ROOM OR CURRENT CONTAINER (CHEST ETC)
	var items_list = get_right_item_list()
	
	#### LOOK FOR ITEM IN LIST
	var item = look_for_item_in_list(items_list, second_word)
	
	#### IF ITEM FOUND, USE IT		
	if item != null:
	
		if item is ItemContainer:
			#if item.is_in_group("containers"):
			return "You can't pick up a container."
		
		else:
			if current_container != null:
				current_container.remove_item(item)
			else:
				current_room.remove_item(item)
			
			
			player.put_in_inventory(item)
			
			items_list = get_right_item_list()
			visual_panel.set_items_list(items_list, current_container)
			return "You pick up a %s!" % item.item_name
				
				
	return "No such item is here."


func get_right_item_list():
	
	if game_situation == Situations.CONTAINER:
		return current_container.get_children()
	return current_room.get_items()


func forget_current_container():
	pass


func open(second_word: String) -> String:
	
	var item = look_for_item_in_list(current_room.get_items(), second_word)
	
	#### IF ITEM FOUND, USE IT		
	if item != null:
	
		#### IS CHEST ETC:
		#### SET PROPER SITUATION, DISPLAY ITEMS INSIDE
		if item is ItemContainer:
			
			game_situation = Situations.CONTAINER
			current_container = item
			
			visual_panel.set_items_list(item.get_children(), item)
			return "You pry open the %s." % item.item_name
		
			
	return "There's no container here."



func drop(second_word: String) -> String:
	
	var inv = player.get_inventory()
	
	if second_word.empty():
		return "Insert second word (item name) to drop item."
		
	if inv.empty():
		return "Your inventory is empty: no items to drop."
	
	#### Look for item in inventory
	#### LOOK FOR ITEM IN INVENTORY
	var item = look_for_item_in_list(inv, second_word)
	
	#### IF ITEM FOUND, USE IT		
	if item != null:
		
		player.remove_from_inventory(item)
		current_room.add_item_scene(item)
		visual_panel.set_items_list(current_room.get_items())
		return "You drop a %s on the ground!" % item.item_name
	
	
	#### Item not found.
	return "You possess no such item."
	

func look_for_item_in_list(item_list, item_id: String) -> Node:
	
	var nums = ["1","2","3","4","5","6","7","8","9",10,11,12,13,14,15,16,17,18,19,20]
	var item = null
	
	#### Get ITEM by its NUMBER in list (inventory for example)
	if item_id in nums:
			
		var num = int(second_word)
		if item_list.size() >= num - 1:
			item = item_list[num - 1]
	
	#### Get ITEM by BROWSING the list (inventory etc)		
	for item2 in item_list:
		if second_word.to_lower() == item2.item_id.to_lower():
			item = item2
				
	return item
	
	
	
func use(second_word) -> String:
	
	var inv = player.get_inventory()
	
	if second_word.empty():
		return "Insert second word (item name) to use item."
		
	if inv.empty():
		return "Your inventory is empty: no items to use."
	
	
	#### LOOK FOR ITEM IN INVENTORY
	var item = look_for_item_in_list(inv, second_word)
	
	#### IF ITEM FOUND, USE IT		
	if item != null:
		match item.item_type:
			
			"key":
				return use_key(item)
			_:
				return "Error: use case to be implemented"
					
	#### Item not found.
	return "You possess no such item."
	

func use_key(item):
	
	for exit in current_room.exits.values():
		if exit.room_2.room_id == item.use_value:
			exit.unlock_exit(current_room)
			player.remove_from_inventory(item)
			
			visual_panel.set_exits_list(current_room.exits, current_room)
			return "You unlocked %s! The %s is lost." % [exit.exit_type, item.item_name]
								
	return "No valid doors for this key in this room."

func inventory() -> String:
	
	return player.create_inventory_string()


func help():
	
	visual_panel.display_alt_panel()
	visual_panel.display_help()
	
	return "Help displayed."
	
	
func hide():
	
	visual_panel.hide_alt_panel()
	visual_panel.hide_help()
	return "Help hidden."

		
#### SET the provided Room as CURRENT room, provide flavor TEXT	
func change_room(new_room) -> String:
	
	#### 1: CHANGE ZONE here too? Alternate to normal: call change_room on new zone's room	
	if new_room.type == Types.RoomTypes.ZONE_SWITCH:
		
		var game_root = get_tree().root.get_node("GameRoot")
		var new_zone = game_root.get_node(new_room.switch_to_zone)
		var new_start_room = new_zone.get_node(new_room.switch_to_room)
		
		var switch_message = "You travel from %s to %s!" % [current_zone.zone_name, new_zone.zone_name]
		text_window.handle_adding_message(switch_message, Color.lightgreen)
		
		current_zone = new_zone
		change_room(new_start_room)
	
	
	#### 2: Called in BASIC rooms and AFTER room switch (the If above)
	else:
		
		current_room = new_room
		var zone = current_room.get_parent().get_parent()
		#DataScene.get_command_parser().current_zone
		
		var visual_panel = DataScene.get_visual_panel()
		visual_panel.set_room_label(current_room.room_name)
		visual_panel.set_zone_label("in " + zone.zone_name)
		visual_panel.build_zonemap()
		visual_panel.change_room_icon()
		
		
		var items_list = current_room.get_items()
		visual_panel.set_exits_list(current_room.exits, current_room)
		visual_panel.set_items_list(items_list, null)
		
		
		#### TEXT WINDOW PRINTOUT
		var change_string = current_room.create_room_description()
		text_window.handle_adding_message(change_string, Color.white)
		
		#### NPC INFO
		var npc_text = current_room.create_npc_description()
		if npc_text != "":
			text_window.handle_adding_message(npc_text, Color.lightgreen)
	
	return ""


#### CREATE a PoolStringArray
func create_pool_string(array: Array, delienator: String):
	
	return PoolStringArray( array ) .join(delienator)






