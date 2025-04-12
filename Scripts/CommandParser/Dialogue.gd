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
		
		first_name = character.npc_name.split(" ")[0]
		
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
		
		
		"quest", "quests":
			return quest(input)
			
			
		
		"give":
			
			return quest(input)
			
			
			
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
			
			return handle_keyword_system(input)
							
	return "Among us"



func quest(input) -> String:
	
	var npc = current_dialogue_npc
	if npc.quests.empty():
		text_window.create_custom_row(input, name_and_quote("I don't seem to have any quests to offer you."))
		return ""
	
	#### GET FIRST QUEST IN LIST - OTHERS WILL NOT BE AVAILABLE, ONLY 1 at a time
	var quest = npc.quests[0]
	
	#### NOTE: DATA SCENE STUFF; REDO LATER
	if not quest in DataScene.known_quests:
		DataScene.known_quests.append(quest)
		text_window.handle_adding_message("You learn of a new Quest: %s." % quest.quest_name, green_c)
		
	
	
	if parser.second_word == "":
		text_window.create_custom_row(input, name_and_quote("Yes, I have need of your services, if you'd be interested in a Quest."))
	else:
		text_window.create_custom_row(input, name_and_quote("You have something for me?"))
	
	if quest.give_item_id != "":
		give(input, parser.second_word, quest)
		
	return ""



func give(input:String, second_word:String, quest:Node):
	
	#if quest == null or quest.has_method("add_quest"):
		#text_window.handle_adding_message(name_and_quote("CODE IS BROKE"), white_c )
		#return 
	
	var inv = player.get_inventory()
	var item = null
	var npc = current_dialogue_npc
	var first_name = npc.npc_name.split(" ")[0]
	
	if quest.give_item_id != "" and quest.receive_item_id != "":
		
		match second_word:		
			"":
				text_window.handle_adding_message(name_and_quote("I need an item. Can you Give it to me?"), white_c)
				text_window.handle_adding_message(name_and_quote(quest.quest_text), white_c )
				text_window.handle_adding_message("They want this item: " + quest.give_item_id, yellow_c)
		
			quest.give_item_id:
				
				item = parser.look_for_item_in_list(inv, second_word)
				if item == null:
					text_window.handle_adding_message(name_and_quote("Yes, that's the item. You don't have it, though."), white_c)
				
				else:
					text_window.handle_adding_message(name_and_quote("You have the item I want!"), white_c)
					text_window.handle_adding_message(name_and_quote(quest.completion_text), white_c)
					
					text_window.handle_adding_message("You give the " + item.item_name + " away!", yellow_c)
					player.remove_from_inventory(item)
					
					var grant_item = DataScene.get_file_reader().get_item_by_id(quest.receive_item_id)
					text_window.handle_adding_message("You receive the " + grant_item.item_name + "!", yellow_c)
					player.put_in_inventory(grant_item)
			_:
				text_window.handle_adding_message(name_and_quote("I don't need that kind of item."), white_c)
			
	else:
		text_window.handle_adding_message(name_and_quote("No, I don't need anything you can Give me."), white_c)
	
	
func grant(second_word):
	pass


func handle_keyword_system(input:String) -> String:
	
	var word_found = false
	var npc_word = ""
	
	#### YOU DON'T KNOW THIS WORD
	if not input in DataScene.known_keywords:
		text_window.create_custom_row(input, "That keyword is unknown to you.")
		return ""
	
	
	#### Get RESPONSE using TOPIC resource
	for word in get_npc_keywords():
		
		if input == word:
			word_found = true
			npc_word = word
	
	
	#### YOU and the NPC Both KNOW the word			
	if word_found:
		
		text_window.create_custom_row(input, "")
		
		#var topic_path = DataScene.get_topic_resource(input)
		#var topic = load(topic_path)
		var topic = DataScene.get_topic_resource(input)
		
		#### Print TOPIC TEXT
		var response = "%s: '%s' \n" % [first_name, topic.topic_text]
		text_window.handle_adding_message(response, white_c)
		
		#### KEYWORDS included and new words LEARNED
		var keyword_str = ""
		for rel in topic.related_topics:
			keyword_str += rel + ", "
			
		response = "Keywords: %s" % keyword_str
		text_window.handle_adding_message(response, yellow_c)
		
		
		learn_new_keywords(topic)
		
		return ""
		
	else:
		text_window.create_custom_row(input, name_and_quote("I'm sorry, I know nothing about that."))
		return ""



func learn_new_keywords(topic):
	
	for id in get_topic_keywords(topic):
		
		var new_topic = DataScene.get_topic_by_id(id)
		
		#### IF A NEW TOPIC EXISTS...
		if not new_topic == null:
			var keyword = new_topic.keyword
				
			if not keyword in DataScene.known_keywords:
				
				DataScene.known_keywords.append(keyword)
				text_window.handle_adding_message("You learn a new topic: %s." % keyword, green_c)
			
	display_keywords()



func get_npc_keywords():
	
	var keyword_str = current_dialogue_npc.npc_keywords
	return keyword_str.split(",")


func get_topic_keywords(topic):
	
	var keywords = topic.related_topics
	return keywords


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



