extends Node



var items_path := "res://DataFiles/items.txt"
var topics_path := "res://DataFiles/topics.txt"

#onready var ItemScript = load("res://Resources/Item.gd")
onready var ItemScene = preload("res://ScenesMisc/ItemScene.tscn")
onready var TopicScene = preload("res://ScenesMisc/Topic.tscn")


func _ready():
	
	#read_items_file_to_list()
	#read_topics_file_to_list()
	
	
	#### DEBUG
	#yield(get_tree(), "idle_frame")
	pass
	
	





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
		
	return items



#### CALLED BY ABOVE FUNCTION
func create_item_from_line(line: String) -> Node:
	
	var parts = line.split(",")
	for p in parts:
		p = p.strip_edges()
		
	var item = ItemScene.instance()
	if parts.size() >= 5:
		item.setup(parts[0],parts[1],parts[2],parts[3],parts[4])
		
	return item


	
#### USED TO FETCH SPECIFIC ITEM AND RETURN A DUPLICATE OF IT
#### GET GLOBAL ALL-ITEMS LIST, MADE ON OPENING GAME
func get_item_by_id(id: String) -> Node:
	
	var item_scenes = DataScene.get_all_items()
	for item in item_scenes:
		
		#### WE CREATE DUPLICATE ITEM
		if item.item_id == id:
			return create_new_item(item)
	
	return null
	
	

#### USED IN ABOVE FUNCTION
func create_new_item(old_item: Node) -> Node:
	var it = old_item
	var item = ItemScene.instance()
	item.setup(it.item_id, it.item_name, it.item_type, it.use_value, it.sell_price)
	
	return item




#########################################################################################################



func read_topics_file_to_list() -> Array:
	
	var topics := []
	
	var file = File.new()
	file.open(topics_path, File.READ)
	
	var file_text : String = file.get_as_text()
	var  segments := file_text.split("####")
	
	for s in segments:
		if not s.empty():
			
			topics.append(create_topic_from_line(s))
			
			
	return topics



#### CALLED BY ABOVE FUNCTION
func create_topic_from_line(segment: String) -> Node:
	
	var lines_1 = segment.split("\n")
	var lines_2 = []
	
	for l in lines_1:
		if not l.empty() && l.substr(0,1) == "*":
			
			l = l.replace("*", "")
			l = l.strip_edges()
			lines_2.append(l)
	
	#for l in lines_2:
		
		
	var item = TopicScene.instance()
	
	 
	if lines_2.size() >= 4:
		var parts = lines_2
		
		var new_words := []
		for w in parts[3].split(","):
			w = w.strip_edges()
			new_words.append(w)
		
		item.setup(parts[0], parts[1], parts[2], new_words)
		
	return item

















	
