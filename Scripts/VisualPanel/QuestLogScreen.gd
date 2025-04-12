extends PanelContainer



onready var QuestInfoPanel = preload("res://ScenesMisc/MiscUI/QuestInfoPanel.tscn")

onready var quest_rows = $Margin/QuestRows


func setup():
	
	quest_rows.wipe_history()
	
	quest_rows.handle_adding_message("Known Quests:", Color.white)
	
	
	var quests = DataScene.get_known_quests()
	
	for q in quests:
		
		var info_panel = QuestInfoPanel.instance()
		info_panel.setup(q)
		quest_rows.add_output_message(info_panel)
