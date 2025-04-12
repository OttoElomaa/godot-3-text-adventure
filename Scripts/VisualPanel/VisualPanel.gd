extends VBoxContainer

const OutputMessage = preload("res://Scenes/OutputMessage.tscn")

onready var top_panel := $TopPanel
onready var bottom_panel := $BottomPanel
onready var alt_panel := $AltPanel
onready var help_panel := $AltPanel/HelpPanel

var parser = null



# Called when the node enters the scene tree for the first time.
func _ready():
	
	hide_alt_panel()


func build_zonemap(room:Node):
	
	$TopPanel/Margins/HBox/MapVbox/Center/ViewportCont/Viewport/ZoneMap.build_zonemap(room)



#### CALLED IN COMMANDPARSER'S CHANGE_ROOM?
func change_room_icon(zone):
	
	var room_sprite = $TopPanel/Margins/HBox/ArtVBox/Center/ViewportCont/Viewport/RoomSprite
	var encounter_sprite = $TopPanel/Margins/HBox/ArtVBox/Center/ViewportCont/Viewport/RoomSprite/EncounterSprite
	var npc_sprite = $TopPanel/Margins/HBox/ArtVBox/Center/ViewportCont/Viewport/RoomSprite/NpcSprite
	var background = $TopPanel/Margins/HBox/ArtVBox/Center/ViewportCont/Viewport/RoomSprite/Background
	
	encounter_sprite.hide()
	npc_sprite.hide()
	var room = DataScene.get_command_parser().current_room
	
	room_sprite.texture = room.room_icon
	background.texture = zone.zone_background
	
	#### SHOW THE CORRECT ADDITIONAL SPRITE
	if room.has_combat:
		encounter_sprite.show()
	if room.room_character != null:
		npc_sprite.show()



func display_alt_panel():
	
	top_panel.hide()
	bottom_panel.hide()
	
	alt_panel.show()
	
	

func hide_alt_panel():

	alt_panel.hide()
	
	top_panel.show()
	bottom_panel.show()
	


func hide_other_alt_screens(screen:Node):
	
	display_alt_panel()
	
	for view in $AltPanel.get_children():
		
		if view == screen:
			view.show()
		else:
			view.hide()


func display_inventory():
	
	var inventory_screen = $AltPanel/InventoryScreen
	hide_other_alt_screens(inventory_screen)
	inventory_screen.setup()
	


func display_quest_log():
	
	var quest_screen = $AltPanel/QuestLogScreen
	hide_other_alt_screens(quest_screen)
	quest_screen.setup()
	
	



func display_help():

	hide_other_alt_screens($AltPanel/HelpPanel)
	
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
	
	hide_other_alt_screens($AltPanel/DialogueScreen)
	
	$AltPanel/DialogueScreen/HBox/CharacterVBox/CharNameLabel.text = npc.npc_name
	$AltPanel/DialogueScreen/HBox/CharacterVBox/CharDescLabel.text = npc.npc_description
	$AltPanel/DialogueScreen/HBox/CharacterVBox/CharDescLabel.modulate = Color.cornsilk
	
	$AltPanel/DialogueScreen/HBox/CharacterVBox/VPCont/Viewport/Sprite.texture = npc.npc_portrait
	

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
func set_items_list(item_list, container_or_null):
	
	#### Get the PANEL set up properly
	var items_panel = $BottomPanel/Margins/HBox/ItemsRows
	items_panel.wipe_history()
	
	#### Iterate through Room's ITEMS?
	var counter = 0
	var color = Color.whitesmoke
	
	
	
	#### DISPLAY TITLE IN COOL WAY
	var item_list_title = "Items:"
	
	if container_or_null != null:
		item_list_title = "Items in %s:" % container_or_null.item_name
	items_panel.handle_adding_message(item_list_title, Color.mediumpurple)	
	#if parser.game_situation == Types.GameSituations.CONTAINER:
	
	
	if item_list.empty():
		items_panel.handle_adding_message("No items in this location.", color)	
		
	for item_scene in item_list:
		#print("DEBUG:")
		#print(item_scene.item_name)
		var count_str = str(counter + 1)
		items_panel.handle_adding_message("%s: %s (%s)" % [count_str, item_scene.item_name, item_scene.item_id], color)
			#if item.has_method("i_am_a_container"):
		
		counter += 1
		


func wipe_keyword_list():
	
	var keyword_rows = $AltPanel/DialogueScreen/HBox/Scroll/KeywordRows
	keyword_rows.wipe_history()


func populate_keyword_list(word):
	
	var keyword_rows = $AltPanel/DialogueScreen/HBox/Scroll/KeywordRows
	keyword_rows.handle_adding_message(word, Color.white)




