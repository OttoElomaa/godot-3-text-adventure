extends Node

class_name ItemContainer


var items = []
var container_types = null

#class_name ItemContainer

export (Resource) var type_resource = null

var type = Types.ContainerTypes.CHEST

var item_name: String = "Container Name"
var item_id = "useless-id"


var description: String = "Container Description"
var items_string: String = ""


func _ready():
	
	pass
	#get_items_from_list()


func setup(resource):
	
	give_properties(resource)
	
	call_deferred("get_items_from_list")



func give_properties(resource):
	
	item_name = resource.item_name
	item_id = resource.item_id
	type = resource.type
	description = resource.description
	
	container_types = resource.Containers
	items_string = resource.items_string
	
	#match type:
		#"chest":
			#pass


func get_items_from_list():
	
	
	#### GET LIST OF ALL ITEMS
	var root = DataScene.get_game_root()
	var items = root.get_node("FileReader").read_items_file_to_list()
	
	#### GET MY ITEMS (IN CHEST)
	var my_items = items_string
	if my_items == "":
		return	
		
	var strings = my_items.split(",")
	
	
	#### MATCH THEM TOGETHER
	for stri in strings:
		for item in items:
			
			if stri == item.item_id:
				self.add_child(item)


func remove_item(item):
	
	remove_child(item)


func printout():
	
	var ret_str = ""
	for item in self.get_children():
		ret_str += item.item_name

			
func i_am_a_container():
	
	var among_us = item_name
	return among_us
	




