extends Node


const WoodenDoor = preload("res://Resources/Types/WoodenDoor.tres")
const MetalDoor = preload("res://Resources/Types/ExitMetalDoor.tres")
const Passage = preload("res://Resources/Types/ExitPassage.tres")

onready var ItemScene := preload("res://ScenesMisc/ItemScene.tscn")
onready var QuestScene := preload("res://ScenesMisc/QuestScene.tscn")

export (String) var zone_id = "000"
export (String) var zone_name = "Zone Name"

export (Texture) var zone_background = null
export (Texture) var zone_map_room_icon = null


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
	
	hallway1.connect_exit_normal("south", evil_cave, Passage)
	hallway1.connect_exit_normal("north", white_room, Passage)
	hallway1.connect_exit_locked("east", shrine, MetalDoor)
	
	shrine.connect_exit_normal("south", antechamber, WoodenDoor)
	antechamber.connect_exit_normal("south", cave, WoodenDoor)
	
	#### EXIT ROOM; TESTING ATM -> OK it works
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
	hallway1.add_item_scene(bone)
	
	#### DEBUG
	var key3 = DataScene.get_file_reader().get_item_by_id("exit-key")
	antechamber.add_item_scene(key3)
	
	#### NPCS
	
	var elf_npc = $NPCs/ElfExplorer
	add_npc(elf_npc, white_room)
	#white_room.add_npc(npc_elf)
	
	var quest1 = $Quests/BoneQuest
	elf_npc.add_quest(quest1)

	
	
	
func get_room(input:String) -> Node:
	return $Rooms.get_node(input)
	


func add_npc(npc:Node, room:Node):
	
	npc.setup()
	room.add_npc(npc)




