extends Control


var inventory: Array = []
var usable_items := []



func put_in_inventory(item):
	
	inventory.append(item)
	$Items.add_child(item)
	
	if item.is_usable:
		usable_items.append(item)
	
	
	
func remove_from_inventory(item):
	
	inventory.erase(item)
	$Items.remove_child(item)
	


func take_item_from_room(item):
	pass
	
	

func drop_item_in_room(item):
	pass
	
	


func get_inventory():
	return $Items.get_children()


	
func create_inventory_string() -> String:
	
	var usable_str := ""
	var not_usable_str := ""
	
	var items_string = ""
	
	if inventory.size() == 0:
		return items_string + "You carry no items in your inventory."
	
	for item in inventory:
		pass
		
		
	for i in range(inventory.size()):
		
		var item = inventory[i]
		var index_str = String(i + 1)
		if item.is_usable:
			#usable_str += index_str + item.item_name + ", "
			usable_str += "%s: %s (%s), " % [index_str, item.item_name, item.item_id]
		else:
			not_usable_str += "%s: %s (%s), " % [index_str, item.item_name, item.item_id]
	
	
	items_string += "Usable items: \n"
	items_string += usable_str + "\n"
	items_string += "Other items: \n"
	items_string += not_usable_str
	
	return items_string





