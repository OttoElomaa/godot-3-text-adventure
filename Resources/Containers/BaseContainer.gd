extends Resource



enum Containers {
	
	NONE, CHEST, WARDROBE, BARREL,
}


export (Containers) var type = Containers.CHEST

export (String) var item_name = "Container Name"
export var item_id = "useless-id"


export (String, MULTILINE) var description = "Container Description"
export (String, MULTILINE) var items_string = ""


