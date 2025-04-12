extends Node




func go(input:String, second_word: String, parser:Node) -> String:
	
	#### No SECOND word
	if second_word.empty():
		return "Insert second word (direction) to walk."
	
	
	#### ALLOW redirects from shorthands
	match second_word:
		"s":
			parser.second_word = "south"
		"n":
			parser.second_word = "north"
		"e":
			parser.second_word = "east"
		"w":
			parser.second_word = "west"
	
	#### VALID second word
	var room = parser.current_room
	var word = parser.second_word
		
	if room.has_exit(word):
		var exit = room.exits[word]
		
		if exit.check_is_other_room_locked(room):
			return "You find the entrance to be locked!"
		else:
			parser.text_window.create_custom_row(input, "You walk %s!" % word)
			parser.change_room( exit.get_other_room(room) )
			
			return ""
	
	#### INVALID second word	
	else:
		return "Invalid direction to walk."
