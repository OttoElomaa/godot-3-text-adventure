tool
extends PanelContainer
class_name GameRoom


onready var ItemScene = load("res://ScenesMisc/ItemScene.tscn")

######################################

export (int) var room_id = 0


export (String) var room_name = "" setget set_room_name
export (String, MULTILINE) var room_description = "" setget set_room_description

export (Texture) var room_icon = null

#### For the ZONE SWITCH room: goal zone and its room.
export (String) var switch_to_zone = ""
export (String) var switch_to_room = ""

export (Types.RoomTypes) var type = Types.RoomTypes.BEDROOM
export (bool) var has_custom_text = false



#### Exits, Items, NPC character (just 1)

var exits: Dictionary = {}
var items: Array = []

var room_character = null

export (bool) var has_combat = false


func _ready():
	
	for node in get_children():
		
		if node.is_in_group("containers"):
			
			items.append(node)
	
	#### Throw em in the Containers sub-node		
	add_containers()
			

func set_room_name(name_input: String):
	
	room_name = name_input
	$Margins/Scroll/Rows/RoomName.text = name_input
	
	
func set_room_description(desc_input: String):
	
	room_description = desc_input
	$Margins/Scroll/Rows/RoomDescription.text = desc_input



func connect_exit_normal(direction: String, room, exit_type):
	
	_connect_exit(direction, room, false)
	add_exit_type(direction,exit_type)


func connect_exit_locked(direction: String, room, exit_type):
	
	_connect_exit(direction, room, true)
	add_exit_type(direction,exit_type)


func _connect_exit(direction: String, room, is_locked: bool = false):
	
	#### CREATE a RESOURCE for the exit connection
	var exit = Exit.new()
	exit.room_1 = self
	exit.room_2 = room
	exits[direction] = exit
	
	#### Handle LOCKING -> the other room can become inaccessible
	exit.is_side_1_locked = is_locked
	
	#### MATCH the correct direction
	match direction:
		"west":
			room.exits["east"] = exit
		"east":
			room.exits["west"] = exit
		"north":
			room.exits["south"] = exit
		"south":
			room.exits["north"] = exit
			


func add_npc(npc):
	
	room_character = npc



#### Add ITEM SCENE to room
func add_item_scene(item):
	
	$Items.add_child(item)



func remove_item(item):
	
	#items.erase(item)
	$Items.remove_child(item)

	
	
#### For flavor mostly, for now	
func add_exit_type(direction: String, resource):
	
	exits[direction].exit_type = resource.exit_type
	
	
	
func create_room_description() -> String:
	
	#### VISUAL PANEL stuff
	var visual_panel = DataScene.get_visual_panel()
	var text_window = DataScene.get_text_window()
	
	
	#### TEXT PANEL stuff
	var room_string = "You are in %s." % room_name + " " + room_description

	return room_string
	

#### Called in COMMANDPARSER -> Change_Room?
func create_npc_description() -> String:
	
	if room_character == null:
		return ""
	else:
		return "%s, %s is here." % [room_character.npc_name, room_character.npc_description]



#### LIST to use in VISUAL panel
func create_exit_list():
	
	var exits_list = []
	exits_list.append("Exits:")
	for key in exits.keys():
		exits_list.append(exits[key].exit_type + " " + key + ".")
	return exits_list
	
	
	
#### CREATE a PoolStringArray
func create_pool_string(array: Array, delienator: String):
	
	return PoolStringArray( array ) .join(delienator)



func add_containers():
	
	for child in get_children():
		if child.has_method("i_am_a_container"):
			
			remove_child(child)
			$Items.add_child(child)
	

func get_items():
	
	return $Items.get_children()






