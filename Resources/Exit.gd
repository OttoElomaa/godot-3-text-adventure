extends Resource
class_name Exit


var room_1 = null
var is_side_1_locked: bool = false

var room_2 = null
var is_side_2_locked: bool = false

var exit_type = "a door"


func unlock_exit(room):

	if room == room_1:
		is_side_1_locked = false
		
	elif room == room_2:
		is_side_2_locked = false
		

func check_is_other_room_locked(room) -> bool:
	
	if room == room_1:
		return is_side_1_locked
		
	elif room == room_2:
		return is_side_2_locked
		
	else:
		printerr("Exit received invalid room via get_exit")
		return true


func get_other_room(room):
	
	if room == room_1:
		return room_2
		
	elif room == room_2:
		return room_1
		
	else:
		printerr("Exit received invalid room via get_exit")


