extends Node



var items_path := "res://DataFiles/items.txt"

#onready var ItemScript = load("res://Resources/Item.gd")
onready var ItemScene = preload("res://ScenesMisc/ItemScene.tscn")


func _ready():
	
	read_items_file_to_list()

func create_item_from_line(line: String) -> Node:
	
	var parts = line.split(",")
	for p in parts:
		p.strip_edges()
		
	var item = ItemScene.instance()
	if parts.size() >= 5:
		item.setup(parts[0],parts[1],parts[2],parts[3],parts[4])
		
	return item


func read_items_file_to_list() -> Array:
	
	var items := []
	
	var file = File.new()
	file.open(items_path, File.READ)
	
	var file_text : String = file.get_as_text()
	var  lines := file_text.split("\n")
	
	for l in lines:
		
		var line:String = l
		if not line.empty() && line.substr(0,1) != "#":
			
			items.append(create_item_from_line(l))
		
	for item in items:
		item.print_to_string()
		
		#print(l)
	return items
	

func get_item_by_id(id: String) -> Node:
	
	var item_scenes = read_items_file_to_list()
	
	for item in item_scenes:
		
		if item.item_id == id:
			return item
	
	return null
	
	
	
	
