extends VBoxContainer

const OutputMessage = preload("res://Scenes/OutputMessage.tscn")

onready var top_panel = $TopPanel
onready var bottom_panel = $BottomPanel
onready var alt_panel = $AltPanel
onready var help_panel = $AltPanel/HelpPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	
	hide_alt_panel()


func build_zonemap():
	
	$TopPanel/Margins/HBox/MapVbox/Center/ViewportCont/Viewport/ZoneMap.build_zonemap()


func change_room_icon():
	
	var room_sprite = $TopPanel/Margins/HBox/ArtVBox/Center/ViewportCont/Viewport/RoomSprite

	room_sprite.texture = DataScene.get_command_parser().current_room.room_icon


func display_alt_panel():
	
	top_panel.hide()
	bottom_panel.hide()
	
	alt_panel.show()
	
	


func hide_alt_panel():

	alt_panel.hide()
	
	top_panel.show()
	bottom_panel.show()
	

func display_help():

	$AltPanel/DialogueScreen.hide()
	$AltPanel/HelpPanel.show()
	
	var response = "Available commands \n"
	response += "Don't type [], brackets are just for show here  \n"
	response += "Walk / W / Go [Direction] \n"
	response += "Get / G / Take / T [Item name] \n"
	response += "Inv / Inventory to see your items \n"
	response += "Type 'hide' or new command to hide help"
	
	var help_message = OutputMessage.instance()
	help_message.text = response
	$AltPanel/HelpPanel/Margins.add_child(help_message)
	
	
func hide_help():
	
	$AltPanel/HelpPanel.hide()
	

func display_dialogue_screen(current_room):
	
	var npc = current_room.room_character
	
	$AltPanel/HelpPanel.hide()
	$AltPanel/DialogueScreen.show()
	
	$AltPanel/DialogueScreen/HBox/CharacterVBox/CharNameLabel.text = npc.npc_name
	$AltPanel/DialogueScreen/HBox/CharacterVBox/CharDescLabel.text = npc.npc_description
	$AltPanel/DialogueScreen/HBox/CharacterVBox/CharDescLabel.modulate = Color.cornsilk
	
	

#### Functions to DISPLAY GAME INFO on the visual panel

func set_room_label(text):
	
	var room_label = $TopPanel/Margins/HBox/ArtVBox/RoomLabel
	room_label.text = text


func set_zone_label(text):
	
	var zone_label = $TopPanel/Margins/HBox/MapVbox/ZoneLabel
	zone_label.text = text
	

#### CALLED in ROOM Scene
func set_exits_list(exits, room):
	
	var exits_panel = $BottomPanel/Margins/HBox/ExitsRows
	var color = Color.whitesmoke
	
	exits_panel.wipe_history()
	
		
	exits_panel.handle_adding_message("Exits: ", Color.mediumpurple)
	for key in exits.keys():
		if exits[key].room_1 == room:
			if exits[key].is_side_1_locked == true:
				color = Color.indianred
		
		exits_panel.handle_adding_message(exits[key].exit_type + " " + key + ".", color)
		
		


#### CALLED in ROOM Scene		
func set_items_list(item_list):
	
	#### Get the PANEL set up properly
	var items_panel = $BottomPanel/Margins/HBox/ItemsRows
	items_panel.wipe_history()
	
	#### Iterate through Room's ITEMS?
	var counter = 0
	var color = Color.whitesmoke
	
	items_panel.handle_adding_message("Items:", Color.mediumpurple)	
	
	if item_list.empty():
		items_panel.handle_adding_message("No items in this location.", color)	
		
	for item_scene in item_list:
		#print("DEBUG:")
		#print(item_scene.item_name)
		var count_str = str(counter + 1)
		items_panel.handle_adding_message("%s: %s (%s)" % [count_str, item_scene.item_name, item_scene.item_id], color)
			#if item.has_method("i_am_a_container"):
		
			
		for item in item_scene.get_children():
			if item is ItemContainer:
				print("DEBUG. CONTAINER")
				item.print_to_string()
				items_panel.handle_adding_message(item.item_name, color)
		
		counter += 1
		


func wipe_keyword_list():
	
	var keyword_rows = $AltPanel/DialogueScreen/HBox/Scroll/KeywordRows
	keyword_rows.wipe_history()

func populate_keyword_list(word):
	
	var keyword_rows = $AltPanel/DialogueScreen/HBox/Scroll/KeywordRows
	keyword_rows.handle_adding_message(word, Color.white)

