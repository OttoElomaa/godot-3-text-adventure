extends PanelContainer



var yellow_c := Color.burlywood
var green_c := Color.lightgreen


func setup(quest:Node):
	
	
	$Margin/VBox/NameLabel.text = quest.quest_name
	$Margin/VBox/QuestTextLabel.text = quest.quest_text
	
	$Margin/VBox/DescLabel.text = generate_quest_description(quest)
	$Margin/VBox/DescLabel.modulate = yellow_c
	



func generate_quest_description(quest) -> String:
	
	
	var id = quest.give_item_id
	var npc = quest.quest_giver
	
	
	if id != "":
		
		var item = DataScene.get_file_reader().get_item_by_id(id)
		return "%s wants you to find and retrieve the %s." % [npc.npc_name, item.item_name]
	
	return ""
