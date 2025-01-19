extends Node


export (String) var item_id := "Item Id"
export (String) var item_name := "Item Name"
export (String) var item_type := "Type"

export (int) var use_value := 0
export (int) var sell_price := 0

var is_usable = false

#### For FILE READ stuff
func setup_from_id(id: String):
	
	pass



func setup(id, name, type, use_v, price):
	
	item_id = id
	item_name = name
	item_type = type
	
	use_value = int(use_v)
	sell_price = int(price)
	
	if item_type in ["key"]:
		is_usable = true
	
	
	
func print_to_string():
	
	print("ITEM: \n" + item_id + ":")
	print("" + item_name)
	print("" + item_type)
	print("" + str(use_value))
	print("" + str(sell_price))
