extends Resource

enum MobTypes {
	
	BasicMelee, Player, BasicRanged, 
}

enum MobSubTypes {
	
	None, Healer, Vermin, Druid, Reaver
}

export (Resource) var sprite = load("res://Sprites/14b.png")
export (String) var entity_name = ""
export (bool) var is_enemy = true

export (MobTypes) var mob_type = MobTypes.BasicMelee
export (MobSubTypes) var mob_sub_type = MobSubTypes.None

export (int) var health = 100
export (int) var mana = 100

export (int) var armor = 100
export (int) var attack_power = 100
export (int) var spell_power = 100
export (int) var poise = 100
