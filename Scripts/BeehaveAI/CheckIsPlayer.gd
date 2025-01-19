extends ActionLeaf



func tick(actor, blackboard):
	
	#### IF is_enemy, return FAILURE, so the main branch can run for SUCCESS
	#### IF is player, return SUCCESS, terminate tree
	if actor.is_enemy:
		return FAILURE
		
	else:
		return SUCCESS
