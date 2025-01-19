extends Node


var parser = null

var game_root = null
var visual_panel = null
var text_window = null

var current_dialogue_npc = null
var player = null


var first_name = null


var white_c := Color.white
var yellow_c := Color.burlywood
var green_c := Color.lightgreen



func start_dialogue(parser, input):
	
	self.parser = parser
	current_dialogue_npc = parser.current_dialogue_npc
	player = parser.player
	
	visual_panel = parser.visual_panel
	text_window = parser.text_window
	game_root = parser.game_root
	
	greeting(input)


func greeting(input):
		
		var character = current_dialogue_npc
		
		first_name = character.npc_name
		
		visual_panel.display_alt_panel()
		visual_panel.display_dialogue_screen(parser.current_room)
		
		
		
		display_keywords()
		
		var hail_str = "You hail %s!" % character.npc_name
		text_window.create_custom_row(input, "")
		
		text_window.handle_adding_message(hail_str, green_c)
		
		#### Print GREETING LINE and associated KEYWORDS
		text_window.handle_adding_message(name_and_quote(character.greeting_line), white_c)
		text_window.handle_adding_message("Keywords: %s" % character.greeting_keywords, yellow_c)
		
		for word in get_npc_greet_keywords(character):
					
			if not word in DataScene.known_keywords:
				
				DataScene.known_keywords.append(word)
				text_window.handle_adding_message("You learn a new topic: %s." % word, green_c)
				
		display_keywords()



func name_and_quote(text: String) -> String:
	
	return "%s: '%s'" % [first_name, text]




func process_command_dialogue(input: String) -> String:
	
	
	var first_name = current_dialogue_npc.npc_name.split(" ")[0]
	
	parser.split_word(input)
	
	match parser.first_word:
		
	###############################
		#### UNIVERSAL KEYWORDS
		"end", "bye", "goodbye":
			
			parser.game_state = Types.GameStates.EXPLORE
			current_dialogue_npc = null
			visual_panel.hide_alt_panel()
			text_window.create_custom_row(input, "You end the conversation.")
			return ""
		
		
		"you":
			return name_and_quote( "My name is " + current_dialogue_npc.npc_name)
			
		"me":
			return name_and_quote("I don't know who you are.") 
		
		"give":
			
			give(input, parser.second_word)
			
			return ""
			
		"grant":
			
			if current_dialogue_npc.can_receive:
				text_window.create_custom_row(input, name_and_quote("I can't Grant you an item unless you Give something in return."))
				text_window.handle_adding_message(current_dialogue_npc.give_dialogue, white_c)
				
			elif current_dialogue_npc.can_grant:
				text_window.create_custom_row(input, name_and_quote("Yes, I can give you an item."))
				
			else:
				text_window.create_custom_row(input, name_and_quote("Sorry, I have nothing to Grant you."))
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
				text_window.create_custom_row(input, name_and_quote("I'm sorry, I know nothing about that."))
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
				text_window.create_custom_row(input, name_and_quote("Yes, I need an item. Can you Give it to me?"))
				text_window.handle_adding_message(current_dialogue_npc.give_dialogue, white_c)
				text_window.handle_adding_message("They want this item: " + current_dialogue_npc.receive_item_id, yellow_c)
		
			current_dialogue_npc.receive_item_id:
				item = parser.look_for_item_in_list(inv, second_word)
				if item == null:
					text_window.create_custom_row(input, name_and_quote("Yes, that's the item. You don't have it, though."))
				
				else:
					text_window.create_custom_row(input, name_and_quote("You have the item I want!"))
					text_window.handle_adding_message(current_dialogue_npc.post_quest_dialogue, white_c)
					
					text_window.handle_adding_message("You give the " + item.item_name + " away!", yellow_c)
					player.remove_from_inventory(item)
					
					var grant_item = DataScene.get_file_reader().get_item_by_id(npc.grant_item_id)
					player.put_in_inventory(grant_item)
			_:
				text_window.create_custom_row(input, name_and_quote("I don't need that kind of item."))
			
	else:
		text_window.create_custom_row(input, name_and_quote("No, I don't need anything you can Give me."))
	
	
func grant(second_word):
	pass


func handle_keyword_system():
	pass




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



