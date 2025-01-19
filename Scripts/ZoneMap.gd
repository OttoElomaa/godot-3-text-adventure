extends Node2D

const RoomSprite = preload("res://ScenesMisc/MiscUI/RoomSprite.tscn")
var placed_rooms = []

var dirs = {
	north = Vector2.UP,
	south = Vector2.DOWN,
	west = Vector2.LEFT,
	east = Vector2.RIGHT
}

var drawer_pos = Vector2.ZERO

func build_zonemap():
	
	var game_root = get_tree().root.get_node("/root/GameRoot")
	var parser = game_root.get_node("CommandParser")
	var zone = get_tree().root.get_node("/root/GameRoot/Zone")
	var starting_room = parser.current_room
	
	#### WIPE THE MAP
	placed_rooms = []
	for node in get_children():
		if not node == $PlayerSprite:
			node.queue_free()
	
	#### RE-DRAW the map with RECURSIVE function
	var room_sprite = RoomSprite.instance()
	add_child(room_sprite)
	
	$PlayerSprite.position = room_sprite.position
	drawer_pos = room_sprite.position
	
	cycle_rooms(starting_room, room_sprite)
	
				 
	
func cycle_rooms(room, room_sprite):
	
	placed_rooms.append(room)
	
	var other_room = null
	#var pos = Vector2(0,0)
	
	#### Go through a room's EXITS
	for key in room.exits.keys():
		
		#if not room.exits[key] == null: 
		
			#### What DIRECTION is the exit
		for dir in dirs:
			
			drawer_pos = room_sprite.position
			if key == dir:
				drawer_pos += dirs[dir] * 45
				
				var new_room_sprite = RoomSprite.instance()
				add_child(new_room_sprite)
				new_room_sprite.position = drawer_pos
				
				other_room = room.exits[key].get_other_room(room)
				if not other_room in placed_rooms:
					cycle_rooms(other_room, new_room_sprite)
	
