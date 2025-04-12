extends Control


export (Resource) var npc_resource = null

var npc_portrait = null
var npc_name = "NpcName"
var npc_description = "NpcName"

var npc_keywords = "you,me"

var greeting_line = "Hello! This is a standard NPC greeting."
var greeting_keywords = ""

var quests := []




func setup():
	
	var resource = npc_resource
	
	
	npc_portrait = resource.npc_portrait
	npc_name = resource.npc_name
	npc_description = resource.npc_description
	
	npc_keywords = resource.npc_keywords
	
	greeting_line = resource.greeting_line
	greeting_keywords = resource.greeting_keywords
	
	
	

func add_quest(quest:Node):
	
	quests.append(quest)
	quest.quest_giver = self
	
	
