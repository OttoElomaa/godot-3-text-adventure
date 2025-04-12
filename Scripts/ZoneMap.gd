extends Node2D

const RoomSprite = preload("res://ScenesMisc/MiscUI/RoomSprite.tscn")

const RoomSpriteHouse = preload("res://Sprites/zonemap-room-icon-32px.png")
const RoomSpriteHamlet = preload("res://Sprites/zonemap-room-icon-hamlet.png")

const BackgroundHouse = preload("res://Sprites/room-icon-background-v2.png")
const BackgroundHamlet = preload("res://Sprites/room-icon-background-v2-hamlet.png")

var placed_rooms = []

var dirs = {
	north = Vector2.UP,
	south = Vector2.DOWN,
	west = Vector2.LEFT,
	east = Vector2.RIGHT
}

var drawer_pos = Vector2.ZERO

func build_zonemap(starting_room):
	
	var zone = starting_room.get_parent().get_parent()
	switch_background(zone, $PlayerSprite/Background)
	
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
	
	
	#switch_sprite(zone, room_sprite)
	
	cycle_rooms(starting_room, room_sprite)
	
				 
	
func cycle_rooms(room, room_sprite):
	
	placed_rooms.append(room)
	var other_room = null
	room_sprite.hide_exits()
	
	
	var zone = room.get_parent().get_parent()
	switch_sprite(zone, room_sprite)
	
	
	#### Go through a room's EXITS
	#### DIRS = Just a list (dict) of cardinal directions
	for key in room.exits.keys():
		for dir in dirs.keys():
			
			#### IF ROOM HAS EXIT WITH VALUE = KEY
			if key == dir:
				#### DRAW CONNECTION BETWEEN ROOMS
				room_sprite.draw_exit(key)
				
				#### WAS 45
				drawer_pos = room_sprite.position
				drawer_pos += dirs[dir] * 48
				
				
				
				#stuff(room, key)
				other_room = room.exits[key].get_other_room(room)
				if not other_room in placed_rooms:
					
					var new_room_sprite = RoomSprite.instance()
					add_child(new_room_sprite)
					new_room_sprite.position = drawer_pos
					cycle_rooms(other_room, new_room_sprite)
					
#func stuff(room, key):
				

func switch_background(zone, background):
	background.texture = zone.zone_background
	

func switch_sprite(zone, room_sprite):
	room_sprite.texture = zone.zone_map_room_icon
	
	
		
		
			
"""match zone.zone_id:
		"001":
			background.texture = BackgroundHouse
		"002":
			background.texture = BackgroundHamlet
			
		match zone.zone_id:
		
		"001":
			room_sprite.texture = RoomSpriteHouse
		
		"002":
			room_sprite.texture = RoomSpriteHamlet	
			"""			
