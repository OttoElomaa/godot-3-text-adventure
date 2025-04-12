extends Control


export (Resource) var background_texture = load("res://Sprites/14b.png")

export (String) var core_loot = ""
export (String) var optional_loot = ""
export (String) var rare_loot = ""


func get_enemies():
	return $Enemies
	
	
func get_texture():
	return background_texture
