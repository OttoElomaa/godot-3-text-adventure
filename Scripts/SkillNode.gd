extends Node


export (Resource) var skill_resource = null

var enum_targeting = null
var enum_skill_types = null
var enum_status_effects = null

##############
var skill_name := "SkillName"
var description := "SkillDescription"

var targeting = null
var skill_type = null

var damage := 0
var healing := 0

var cooldown := 0

var combat: Node = null
var battler: Node = null

var target_group = null
var target: Node = null

var has_status_effect = null
var status_duration := 0
var status_amount := 0

var status_effect = null	
var status_effect_str := ""

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#setup(self.skill_resource)
	pass
	
	
func setup(resource):

	combat = DataScene.get_combat_screen()

	enum_targeting = resource.Targeting
	enum_skill_types = resource.SkillTypes
	enum_status_effects = resource.StatusEffects


	skill_name = resource.skill_name
	description = resource.description

	targeting = resource.targeting
	skill_type = resource.skill_type

	damage = resource.damage
	healing = resource.healing
	cooldown = resource.cooldown
	
	has_status_effect = resource.has_status_effect
	status_duration = resource.status_duration
	status_amount = resource.status_amount
	
	status_effect = resource.status_effect
	status_effect_str = resource.status_effect_str
	

func activate(actor):
	
	battler = actor
	target = battler.target
	$BeehaveRoot.tick(1)



func get_target_group(character):
	
	if character.is_enemy:
		
		if targeting == enum_targeting.FRIENDLY:
			return combat.enemy_group
		elif targeting == enum_targeting.HOSTILE:
			return combat.ally_group
		else:
			pass
	
	else:
		
		if targeting == enum_targeting.FRIENDLY:
			return combat.ally_group
		elif targeting == enum_targeting.HOSTILE:
			return combat.enemy_group
		else:
			pass
		
			

func handle_skill_use_info():
	
	combat.handle_combat_output("\n" + battler.entity_name + " uses " + skill_name + "!", Color.white)
		
			

func deal_damage(target):
	
	var color = Color.gold
	if battler.is_enemy:
		color = Color.lightcoral
	
	target.stats.health -= damage
	
	var text = "%s takes %d damage!" % [target.entity_name, damage]
	combat.handle_combat_output(text, color)

	if target.is_enemy:
		target.play_anim_hurt()
	target.handle_damage()
	
	

#### WIP	
func heal(target):
	
	var color = Color.aquamarine
	if battler.is_enemy:
		color = Color.cornflower
	
	var heal_diff = target.stats.max_health - target.stats.health
	if target.stats.health + healing > target.stats.max_health:
		healing = heal_diff
		
	target.stats.health += healing
	
	
	var text = "%s is healed by %d!" % [target.entity_name, healing]
	combat.handle_combat_output(text, color)

	#target.handle_damage()	

