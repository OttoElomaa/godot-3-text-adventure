extends Battler


var inventory: Array = []
var usable_items := []



func take_item(item):
	
	inventory.append(item)
	$Inventory.add_child(item)
	
	if item.is_usable:
		usable_items.append(item)
	

func drop_item(item):
	
	inventory.erase(item)
	$Inventory.remove_child(item)
	


func get_inventory():
	
	return $Inventory.get_children()


	
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
			not_usable_str += i + item.item_name + ", "
	
	
	items_string += "Usable items: \n"
	items_string += usable_str + "\n"
	items_string += "Other items: \n"
	items_string += not_usable_str
	
	return items_string





