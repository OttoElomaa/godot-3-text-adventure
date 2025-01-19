extends Node


export (Resource) var skill_resource = null

##############
export (String) var skill_name = "SkillName"
export (String) var description = "SkillDescription"

export (int) var damage = 0
export (int) var healing = 0

var combat = null
var battler = null

var target_group = null
var target = null


# Called when the node enters the scene tree for the first time.
func _ready():
	
	setup(self.skill_resource)
	
	
func setup(resource):

	combat = DataScene.get_combat_screen()

	skill_name = resource.skill_name
	description = resource.description

	damage = resource.damage
	healing = resource.damage


func activate(actor):
	
	battler = actor
	
	if actor.is_enemy == true:
		target_group = combat.ally_group
		
	else:
		target_group = combat.enemy_group
	
	$BeehaveRoot.tick(1)


func deal_damage(target):
	
	var color = Color.gold
	if battler.is_enemy:
		color = Color.lightcoral
	
	target.stats.health -= damage
	
	var text = "%s takes %d damage!" % [target.entity_name, damage]
	combat.handle_combat_output(text, color)

	target.handle_damage()
