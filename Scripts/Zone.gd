extends Node


const WoodenDoor = preload("res://Resources/Types/WoodenDoor.tres")
const MetalDoor = preload("res://Resources/Types/ExitMetalDoor.tres")
const Passage = preload("res://Resources/Types/ExitPassage.tres")

onready var ItemScene := preload("res://ScenesMisc/ItemScene.tscn")

export (String) var zone_name = "Zone Name"


onready var first_room = $Rooms/Room
onready var hallway1 = $Rooms/Hallway1
onready var white_room = $Rooms/CustomRoom
onready var shrine = $Rooms/Shrine1

onready var antechamber = $Rooms/Antechamber
onready var switch_room = $Rooms/SwitchRoom
onready var cave = $Rooms/Cave1
onready var evil_cave = $Rooms/EvilCave

		
	
func setup():
	
	#yield(get_tree().create_timer(0.1), "timeout")
	
	var my_rooms = [first_room, hallway1, white_room, shrine, antechamber, switch_room, cave, evil_cave]
	
	#### CONNECTIONS
	
	first_room.connect_exit_normal("east", hallway1, WoodenDoor)
	first_room.connect_exit_normal("west", evil_cave, Passage)
	
	hallway1.connect_exit_normal("north", white_room, Passage)
	
	#### EXIT ROOM; TESTING ATM -> OK it works
	
	hallway1.connect_exit_locked("east", shrine, MetalDoor)
	
	shrine.connect_exit_normal("south", antechamber, WoodenDoor)
	antechamber.connect_exit_normal("south", cave, WoodenDoor)
	antechamber.connect_exit_locked("east", switch_room, MetalDoor)
	
	
	
	##########################################################
	#### EVENTS?
	#### ENCOUNTERS
	
	evil_cave.add_encounter($Encounters/GhostsEnc1)
	
	
	#### ITEMS
	
	for room in my_rooms:
		room.add_containers()

	var key2 = DataScene.get_file_reader().get_item_by_id("key")
	hallway1.add_item_scene(key2)
	
	var bone = DataScene.get_file_reader().get_item_by_id("elfbone")
	shrine.add_item_scene(bone)
	
	
	#### NPCS
	
	var npc_elf = load("res://Resources/NPCs/ElfExplorer.tres")
	white_room.add_npc(npc_elf)
	
	
	################################################
	#### LOAD THE MAP
	#DataScene.get_command_parser().change_room(first_room)
	DataScene.get_visual_panel().build_zonemap()

	
	
	

	

