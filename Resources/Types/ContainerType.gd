extends Resource



export (String) var item_name = "Container Name"
#export (String) var type = "Container Type"
export (Types.ContainerTypes) var type = Types.ContainerTypes.CHEST
#export (Resource) var type_resource = null
export (String, MULTILINE) var description = "Container Description"

#export (Array, String) var item_strings = []
export (String) var items_string = ""
