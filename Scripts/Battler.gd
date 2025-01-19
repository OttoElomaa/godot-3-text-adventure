extends Control

class_name Battler

signal battler_finished_turn

onready var SkillScene = preload("res://Scenes/Skill.tscn")

onready var SkillStrike = preload("res://Resources/Skills/Strike.tres")
onready var SkillStrongStrike = preload("res://Resources/Skills/StrongStrike.tres")
onready var SkillFirstAid = preload("res://Resources/Skills/FirstAid.tres")



export (Resource) var battler_resource = null

onready var stats := $Stats
onready var skills := $Skills
onready var texture := $Texture

var battler_info_panel : Control = null


export (String) var entity_name = "Un-defined Enemy"
var is_enemy = true
#export (bool) var is_enemy = true

var is_stunned := false

var combat = null
var target_group = null
var target = null



func _ready():
	
	set_stats_from_resource()
	

func set_as_ally():
	
	is_enemy = false


func check_stunned():
	
	return is_stunned	
	
	
func set_stats_from_resource():
	
	#### Get RESOURCE
	var stat_resource : Resource = null
	
	if battler_resource != null:
		stat_resource = battler_resource
			
	#### Stuff in SELF
	
	entity_name = stat_resource.entity_name
	is_enemy = stat_resource.is_enemy
	
	#### Stuff in Self.STATS node	
	stats.health = stat_resource.health
	stats.mana = 100
	stats.armor = 100
	stats.attack_power = 100
	stats.spell_power = 100
	stats.poise = 100
	
	#### SET SKILLS based on ENEMY TYPE
	var mob_type = stat_resource.mob_type
	var mob_sub_type = stat_resource.mob_sub_type
	set_skills(mob_type, mob_sub_type, stat_resource)
			

func set_skills(mob_type, mob_sub_type, stat_resource):
	
	# Types: BasicMelee, BasicRanged, Healer
	# SubTypes: None, Vermin, Druid
	
	var type_enum = stat_resource.MobTypes
	var sub_type_enum = stat_resource.MobSubTypes
	
	match mob_type:
		
		type_enum.BasicMelee:
			create_skill_node(SkillStrike)
			
		type_enum.Player:
			create_skill_node(SkillStrike)
			create_skill_node(SkillStrongStrike)
			create_skill_node(SkillFirstAid)
	
	
	match mob_sub_type:
		
		sub_type_enum.Druid:
			pass
	
		
		

func create_skill_node(resource):
	
	var skill = SkillScene.instance()
	skill.setup(resource)
	skills.add_child(skill)



func show_skills():
	
	var return_str = ""
	var count = 1
	
	for skill in skills.get_children():	
		return_str += "\n %d: %s \n" % [count, skill.skill_name]
		count += 1
		
	return return_str
		

#### Here: Distinction BETWEEN Player and Not Player (Enemy)
func play_turn():
	
	combat = DataScene.get_combat_screen()
	
	if is_enemy == true:
		target_group = combat.ally_group	
	else:
		target_group = combat.enemy_group
	
	$BeehaveRoot.tick(1)
	emit_signal("battler_finished_turn")
	return is_enemy		
	

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
	combat.dict_enemies_and_sprites[self].hide()
	battler_info_panel.queue_free()
	
	
	
	
	
	
