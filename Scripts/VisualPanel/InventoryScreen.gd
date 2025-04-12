extends PanelContainer


onready var ItemInfoPanel = preload("res://ScenesMisc/MiscUI/ItemInfoPanel.tscn")

onready var equip_rows = $Margins/VBox/EquipmentHBox/EquipRows
onready var item_rows = $Margins/VBox/ItemsRows

func setup():
	
	equip_rows.wipe_history()
	equip_rows.handle_adding_message("Equipped items:", Color.white)
	
	item_rows.wipe_history()
	item_rows.handle_adding_message("Items in Inventory:", Color.white)
	
	var inv = DataScene.get_inventory()
	var items = inv.get_inventory()
	
	for item in items:
		
		var info_panel = ItemInfoPanel.instance()
		info_panel.setup(item)
		item_rows.add_output_message(info_panel)
