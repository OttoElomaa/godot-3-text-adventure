extends Resource

class_name NPC


export (Texture) var npc_portrait = null
export (String) var npc_name = "NpcName"
export (String, MULTILINE) var npc_description = "NpcName"

export (String, MULTILINE) var npc_keywords = "you,me"

export (String, MULTILINE) var greeting_line = "Hello! This is a standard NPC greeting."
export (String, MULTILINE) var greeting_keywords = ""



export (bool) var can_grant = false
export (bool) var can_receive = false

export (String) var grant_item_id = ""
export (String) var receive_item_id = ""

export (String, MULTILINE) var give_dialogue = "Dialogue to show what you must Give the NPC."




export (String, MULTILINE) var post_quest_dialogue = "Hello! You complete quest."






