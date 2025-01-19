extends Node

class_name ItemContainer


var items = []



#class_name ItemContainer

export var item_id = "useless-id"
export (String) var item_name = "Container Name"
#export (String) var type = "Container Type"
export (Types.ContainerTypes) var type = Types.ContainerTypes.CHEST
export (Resource) var type_resource = null
export (String, MULTILINE) var description = "Container Description"

#export (Array, String) var item_strings = []
export (String) var items_string = ""


func _ready():
	
	give_properties(type_resource)
	
	call_deferred("get_items_from_list")
	#get_items_from_list()



func give_properties(resource):
	
	item_name = resource.item_name
	type = resource.type
	description = resource.description
	
	
	#match type:
		#"chest":
			#pass


func get_items_from_list():
	
	var root = DataScene.get_game_root()
	var items = root.get_node("FileReader").read_items_file_to_list()
	
	if items_string == "":
		return
		
	var strings = items_string.split(",")
	for item_str in strings:
		
		for item in items:
			if item_str == item.item_id:
				self.add_child(item)


func printout():
	
	var ret_str = ""
	for item in self.get_children():
		ret_str += item.item_name

			
func i_am_a_container():
	
	var among_us = item_name
	return among_us
	




