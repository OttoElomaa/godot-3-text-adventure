extends ActionLeaf


func tick(actor, blackboard):
	
	for battler in actor.target_group:
		actor.target = battler
	
	actor.combat.handle_combat_output("Target: " + actor.target.entity_name, Color.gray)	
	return SUCCESS
