extends Node



var parser = null

var game_root = null
var visual_panel = null
var text_window = null

var current_dialogue_npc = null
var player = null
var current_room = null

var first_name = null


var white_c := Color.white
var yellow_c := Color.burlywood
var green_c := Color.lightgreen


enum Situations {
	
	NONE, CONTAINER,
}



func setup(parser):
	
	self.parser = parser
	current_dialogue_npc = parser.current_dialogue_npc
	player = parser.player
	
	visual_panel = parser.visual_panel
	text_window = parser.text_window
	game_root = parser.game_root
	
	





func process_command_explore(input):
	
	var response = ""
	
	current_room = parser.current_room
	
	parser.split_word(input)
	var first_word = parser.first_word
	var second_word = parser.second_word
	
	
	if not parser.first_word in ["help", "h"]:
		visual_panel.hide_help()
	
	match first_word:
		
		"go", "walk", "w":
			response = go(input, second_word)
			
		"hail", "h", "speak", "talk",  "salute", "s":
			return hail(first_word)
		
		#"fight", "f":
			#return fight()
				
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
			parser.change_room( exit.get_other_room(current_room) )
			
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
		
		parser.game_state = Types.GameStates.DIALOGUE
		start_dialogue(input, character)
		
		return ""

	
func start_dialogue(input, character):
	parser.current_dialogue_npc = character
	parser.dialogue.start_dialogue(parser, input)






func take(second_word: String) -> String:
	
	
	
	var nums = ["1","2","3","4","5","6","7","8","9",10,11,12,13,14,15,16,17,18,19,20]
	
	var visual_panel = DataScene.get_visual_panel()
	
	if second_word.empty():
		return "Insert second word (item name) to take."
		
	if current_room.get_items().empty():
		return "No items to take!"
	
	
	#### LOOK IN CURRENT ROOM OR CURRENT CONTAINER (CHEST ETC)
	var items_list = parser.get_right_item_list()
	
	#### LOOK FOR ITEM IN LIST
	var item = parser.look_for_item_in_list(items_list, second_word)
	
	#### IF ITEM FOUND, USE IT		
	if item != null:
	
		if item is ItemContainer:
			#if item.is_in_group("containers"):
			return "You can't pick up a container."
		
		else:
			if parser.current_container != null:
				parser.current_container.remove_item(item)
			else:
				current_room.remove_item(item)
			
			
			player.put_in_inventory(item)
			
			items_list = parser.get_right_item_list()
			visual_panel.set_items_list(items_list, parser.current_container)
			return "You pick up a %s!" % item.item_name
				
				
	return "No such item is here."






func open(second_word: String) -> String:
	
	var item = parser.look_for_item_in_list(current_room.get_items(), second_word)
	
	#### IF ITEM FOUND, USE IT		
	if item != null:
	
		#### IS CHEST ETC:
		#### SET PROPER SITUATION, DISPLAY ITEMS INSIDE
		if item is ItemContainer:
			
			parser.game_situation = Situations.CONTAINER
			parser.current_container = item
			
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
	var item = parser.look_for_item_in_list(inv, second_word)
	
	#### IF ITEM FOUND, USE IT		
	if item != null:
		
		player.remove_from_inventory(item)
		current_room.add_item_scene(item)
		#### NULL = NO CONTAINER
		visual_panel.set_items_list(current_room.get_items(), null)
		
		parser.forget_current_container()
		return "You drop a %s on the ground!" % item.item_name
	
	
	#### Item not found.
	return "You possess no such item."







func use(second_word) -> String:
	
	var inv = player.get_inventory()
	
	if second_word.empty():
		return "Insert second word (item name) to use item."
		
	if inv.empty():
		return "Your inventory is empty: no items to use."
	
	
	#### LOOK FOR ITEM IN INVENTORY
	var item = parser.look_for_item_in_list(inv, second_word)
	
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













