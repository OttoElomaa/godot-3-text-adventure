extends Node


const WoodenDoor = preload("res://Resources/Types/WoodenDoor.tres")
const MetalDoor = preload("res://Resources/Types/ExitMetalDoor.tres")
const Passage = preload("res://Resources/Types/ExitPassage.tres")

export (String) var zone_id = "000"
export (String) var zone_name = "Zone Name"

export (Texture) var zone_background = null
export (Texture) var zone_map_room_icon = null


onready var first_room = $Rooms/Meadow1

# Called when the node enters the scene tree for the first time.
func setup():
	
	$Rooms/Meadow1.connect_exit_normal("east", $Rooms/Meadow2, Passage)
	
	$Rooms/Meadow1.connect_exit_normal("north", $Rooms/CombatHub, Passage)
	
	$Rooms/CombatHub.connect_exit_normal("north", $Rooms/Shore3, Passage)
	$Rooms/CombatHub.connect_exit_normal("west", $Rooms/Shore2, Passage)
	$Rooms/CombatHub.connect_exit_normal("east", $Rooms/Shore4, Passage)
	
	
	#### ENCOUNTER
	$Rooms/Shore2.add_encounter($Encounters/Bandit1)
	



func get_room(input:String) -> Node:
	return $Rooms.get_node(input)

