extends Node


#var root = null
var all_items: Array = []
var all_topics: Array = []

var known_quests := []


var known_keywords = ["you", "me", "give", "grant"]



func _ready():
	
	yield(get_tree(), "idle_frame")
	all_items = get_file_reader().read_items_file_to_list()
	all_topics = get_file_reader().read_topics_file_to_list()
	
	
	#### DEBUG
	print("TEST IN DATASCENE.TSCN")
	
	for item in get_all_items():
		item.print_to_string()

	for topic in get_all_topics():
		topic.print_to_string()


###################################################################


func get_all_items():
	return all_items


func get_all_topics():
	return all_topics
	
	
func get_known_quests():
	return known_quests



func get_topic_resource(word: String) -> Node:
	
	word = word.to_lower()
	
	for topic in get_all_topics():
		
		if topic.keyword.to_lower() == word:
			return topic
	
	return null
		
			
func get_topic_by_id(id:String) -> Node:
	
	for topic in get_all_topics():
		
		if topic.topic_id == id:
			return topic
	
	return null


##########################################################
#### FOR NAVIGATION PURPOSES: PASSING ALONG SOME POPULAR NODES


func get_command_parser():
	
	return get_game_root().get_node("CommandParser")



func get_visual_panel():
	
	return get_tree().root.get_node("/root/GameRoot/MainPanel/MarginContainer/Horizontal/VisualPanel")


func get_text_window():
	
	return get_tree().root.get_node("/root/GameRoot/MainPanel/MarginContainer/Horizontal/TextWindow")


func get_game_root():
	
	return get_tree().root.get_node("/root/GameRoot")


func get_combat_screen():
	
	return get_tree().root.get_node("/root/GameRoot/MainPanel/MarginContainer/CombatScreen")


func get_party():
	
	return get_game_root().get_node("Party")


func get_file_reader():
	
	return get_game_root().get_node("FileReader")


func get_inventory():
	
	return get_game_root().get_node("Inventory")




