extends Node



var known_keywords = ["you", "me", "give", "grant"]


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






func get_topic_resource(word: String) -> String:
	
	word = word.to_lower()
	
	match word:
		
		"house":
			
			return "res://Resources/Topics/TopicHouse.tres"
			
		"hamlet":
			
			return "res://Resources/Topics/TopicHamlet.tres"
			
		"city":
			
			return ""
			
	return ""
