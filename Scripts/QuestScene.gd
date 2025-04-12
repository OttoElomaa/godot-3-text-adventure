extends Node


export (Resource) var resource = null

var quest_id := ""
var quest_name := ""

var quest_text := ""
var completion_text := ""

var give_item_id := ""
var receive_item_id := ""

var quest_giver: Node = null



func _ready():
	setup(resource)
	


func setup(resource: Resource):
	
	quest_id = resource.quest_id
	quest_name = resource.quest_name
	
	quest_text = resource.quest_text
	completion_text = resource.completion_text
	
	give_item_id = resource.give_item_id
	receive_item_id = resource.receive_item_id
