extends Node


const WoodenDoor = preload("res://Resources/Types/WoodenDoor.tres")
const MetalDoor = preload("res://Resources/Types/ExitMetalDoor.tres")
const Passage = preload("res://Resources/Types/ExitPassage.tres")

export (String) var zone_name = "Zone Name"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Meadow1.connect_exit_normal("east", $Meadow2, Passage)
	
	"""
	$Room.connect_exit_normal("east", $Hallway1)
	$Room.add_exit_type("east", WoodenDoor)
	
	$Hallway1.connect_exit_normal("north", $CustomRoom)
	$Hallway1.add_exit_type("north", Passage)
	
	#### TEST SHIT REMOVE
	$CustomRoom.connect_exit_normal("north", $HallTest2)
	$Shrine1.connect_exit_normal("east", $HallTest3)
	
	$Hallway1.connect_exit_locked("east", $Shrine1)
	$Hallway1.add_exit_type("east", MetalDoor)
	
	var key_1 = load("res://Resources/ItemKey.tres")
	key_1.use_value = $Shrine1
	#### NOTE: Putting it here now for testing, please put it in CustomRoom later
	$Hallway1.add_item(key_1)
	
	var npc_elf = load("res://Resources/NPCs/ElfExplorer.tres")
	$CustomRoom.add_npc(npc_elf)
	"""
	
	
	
	
	


