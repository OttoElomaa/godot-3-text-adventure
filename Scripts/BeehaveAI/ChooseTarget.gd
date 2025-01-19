extends ActionLeaf


var actor = null

func tick(actor, blackboard):
	
	var combat = DataScene.get_combat_screen()
	self.actor = actor
	
	var skill = blackboard.get("skill_to_use")
	actor.target_group = skill.get_target_group(actor)
	
	
	match skill.skill_type:
		
		skill.enum_skill_types.BasicAttack:
			get_strongest_target()
		
		skill.enum_skill_types.BasicHeal:
			get_weakest_target()
	
	
	
	skill.activate(actor)
	actor.play_anim_attack()
	
	
	#actor.combat.handle_combat_output("Target: " + actor.target.entity_name, Color.gray)	
	return SUCCESS


func get_weakest_target():
	
	var current_target = actor.target_group[0]
	for battler in actor.target_group:
		if battler.stats.health < current_target.stats.health:
			actor.target = battler
		else:
			actor.target = current_target


func get_strongest_target():
	
	var current_target = actor.target_group[0]
	for battler in actor.target_group:
		if battler.stats.health > current_target.stats.health:
			actor.target = battler
		else:
			actor.target = current_target


