extends ConditionLeaf



func tick(actor, blackboard):
	
	#### IF is_stunned = false, return Success
	if actor.check_stunned():
		return SUCCESS
		
	else:
		return FAILURE
	


