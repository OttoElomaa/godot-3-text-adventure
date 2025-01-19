extends Node


const WoodenDoor = preload("res://Resources/Types/WoodenDoor.tres")
const MetalDoor = preload("res://Resources/Types/ExitMetalDoor.tres")
const Passage = preload("res://Resources/Types/ExitPassage.tres")

onready var ItemScene := preload("res://ScenesMisc/ItemScene.tscn")

export (String) var zone_name = "Zone Name"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	yield(get_tree().create_timer(0.1), "timeout")
	#### CONNECTIONS
	
	$Room.connect_exit_normal("east", $Hallway1, WoodenDoor)
	$Room.connect_exit_normal("west", $EvilCave, Passage)
	
	$Hallway1.connect_exit_normal("north", $CustomRoom, Passage)
	
	#### EXIT ROOM; TESTING ATM -> OK it works
	
	$Hallway1.connect_exit_locked("east", $Shrine1, MetalDoor)
	
	$Shrine1.connect_exit_normal("south", $Antechamber, WoodenDoor)
	$Antechamber.connect_exit_normal("south", $Cave1, WoodenDoor)
	$Antechamber.connect_exit_locked("east", $SwitchRoom, MetalDoor)
	
	##########################################################
	#### ITEMS AND NPC'S
	
	#var key_1 = load("res://Resources/ItemKey.tres")
	#key_1.use_value = $Shrine1

	var key2 = DataScene.get_file_reader().get_item_by_id("key")
	$Hallway1.add_item_scene(key2)
	
	var bone = DataScene.get_file_reader().get_item_by_id("elfbone")
	$Shrine1.add_item_scene(bone)
	
	var npc_elf = load("res://Resources/NPCs/ElfExplorer.tres")
	$CustomRoom.add_npc(npc_elf)
	
	
	DataScene.get_visual_panel().build_zonemap()

	
	
	
	
#$Room.add_exit_type("east", WoodenDoor)
	#$Hallway1.add_exit_type("north", Passage)
	#$Hallway1.add_exit_type("east", MetalDoor)
	#$Shrine1.add_exit_type("south", Passage)
	

