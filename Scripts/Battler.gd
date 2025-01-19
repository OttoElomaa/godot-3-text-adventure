extends Control

class_name Battler

signal battler_finished_turn

onready var SkillScene = preload("res://Scenes/Skill.tscn")

onready var SkillStrike = preload("res://Resources/Skills/Strike.tres")
onready var SkillStrongStrike = preload("res://Resources/Skills/StrongStrike.tres")
onready var SkillFirstAid = preload("res://Resources/Skills/FirstAid.tres")



export (Resource) var battler_resource = null
onready var texture := $Texture

onready var stats := $Stats
onready var skills := $Skills
var special_skills := []
var basic_skills := []




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
	
	#### SETUP own components
	$StatusHandler.setup()
	combat = DataScene.get_combat_screen()
	
	#### Get RESOURCE
	var stat_resource : Resource = null
	
	if battler_resource != null:
		stat_resource = battler_resource
			
	#### READ FROM RESOURCE - Stuff in SELF
	
	entity_name = stat_resource.entity_name
	is_enemy = stat_resource.is_enemy
	texture.texture = stat_resource.sprite
	
	#### Stuff in Self.STATS node	
	stats.health = stat_resource.health
	stats.mana = stat_resource.mana
	
	stats.max_health = stats.health
	stats.max_mana = stats.mana
	
	stats.armor = stat_resource.armor
	stats.attack_power = stat_resource.attack_power
	stats.spell_power = stat_resource.spell_power
	stats.poise = stat_resource.poise
	
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
			create_special_skill(SkillStrongStrike)
			create_special_skill(SkillFirstAid)
	
	
	match mob_sub_type:
		
		sub_type_enum.Healer:
			create_special_skill(SkillFirstAid)
			create_special_skill(SkillStrongStrike)
		
		
func create_skill_node(resource):
	
	var skill = SkillScene.instance()
	skill.setup(resource)
	skills.add_child(skill)
	#### Diff:
	basic_skills.append(skill)

func create_special_skill(resource):
	
	var skill = SkillScene.instance()
	skill.setup(resource)
	skills.add_child(skill)
	#### Diff:
	special_skills.append(skill)



#### Here: Distinction BETWEEN Player and Not Player (Enemy)
func play_turn():
	
	$BeehaveRoot.tick(1)
	return is_enemy		


func put_skill_on_cooldown(skill: Node):
	
	$StatusHandler.add_cooldown_counter(skill)



func handle_counters():
	
	$StatusHandler.play_counters_turn()



#### CHECKING COOLDOWN	
func check_for_cooldown(skill: Node):
	
	for counter in $StatusHandler.cooldown_counters:
		if is_instance_valid(counter):
			
			if counter.skill.skill_name == skill.skill_name:
				return true
			
	return false


func get_cooldown_duration(skill: Node) -> int: 
	
	for counter in $StatusHandler.cooldown_counters:
		if is_instance_valid(counter):
			
			if counter.skill.skill_name == skill.skill_name:
				return counter.counter_turns
	
	return 0




#### YOU TAKE DAMAGE
func handle_damage():
	
	if stats.health <= 0:
		remove_battler()	



#### Basically, BATTLER is KILLED for some reason	
func remove_battler():
	
	var combat = DataScene.get_combat_screen()
	
	
	
	combat.battlers.erase(self)
	
	texture.hide()
	
	if is_enemy:
		combat.dict_enemies_and_sprites[self].hide()
		combat.enemy_group.erase(self)
		combat.dead_enemy_list.append(self)
		
	battler_info_panel.queue_free()
	

	
func update_resource_bars():
	
	battler_info_panel.update_resource_bars()	
	
	
	
