extends Control

class_name Battler

signal battler_finished_turn


export (Types.EnemyTypes) var enemy_type = Types.EnemyTypes.GHOST;
export (Resource) var battler_resource = null

onready var stats := $Stats
onready var skills := $Skills
onready var texture := $Texture

var battler_info_panel : Control = null


export (String) var entity_name = "Un-defined Enemy"
export (bool) var is_enemy = true

var is_stunned := false


func _ready():
	
	set_stats_from_resource()
	

func set_as_ally():
	
	is_enemy = false


func check_stunned():
	
	return is_stunned	
	
	
func set_stats_from_resource():
	
	#### Get RESOURCE
	var stat_resource : Resource = null
	
	match enemy_type:
		
		Types.EnemyTypes.GHOST:
			stat_resource = load("res://Resources/Enemies/Ghost.tres")
	
	if battler_resource != null:
		stat_resource = battler_resource
			
	#### Stuff in SELF
	#if is_enemy:
	entity_name = stat_resource.entity_name
	
	
	#### Stuff in Self.STATS node	
	stats.health = stat_resource.health
	stats.mana = 100
	stats.armor = 100
	stats.attack_power = 100
	stats.spell_power = 100
	stats.poise = 100
			


func show_skills():
	
	var return_str = ""
	var count = 1
	
	for skill in skills.get_children():	
		return_str += "\n %d: %s \n" % [count, skill.skill_name]
		count += 1
		
	return return_str
		

#### Here: Distinction BETWEEN Player and Not Player (Enemy)
func play_turn():
	
	if self.is_in_group("player"):
		pass
	
	else:
		$BeehaveRoot.tick(1)
		emit_signal("battler_finished_turn")		
	

func update_resource_bars():
	
	battler_info_panel.update_resource_bars()
	
	
#func reduce_health(damage):
	#pass

#### YOU TAKE DAMAGE
func handle_damage():
	
	if stats.health <= 0:
		remove_battler()	


#### Basically, BATTLER is KILLED for some reason	
func remove_battler():
	
	var combat = DataScene.get_combat_screen()
	
	combat.enemy_group.erase(self)
	combat.battlers.erase(self)
	combat.dead_enemy_list.append(self)
	
	texture.hide()
	battler_info_panel.queue_free()
	
	
	
	
	
	
