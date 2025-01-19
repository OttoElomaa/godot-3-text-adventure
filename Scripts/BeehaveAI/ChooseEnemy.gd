extends ActionLeaf


func tick(actor, blackboard):
	
	var current_target = actor.target_group[0]
	
	for battler in actor.target_group:
		if battler.stats.health > current_target.stats.health:
			actor.target = battler
		else:
			actor.target = current_target
	
	actor.combat.handle_combat_output("Target: " + actor.target.entity_name, Color.gray)	
	return SUCCESS
