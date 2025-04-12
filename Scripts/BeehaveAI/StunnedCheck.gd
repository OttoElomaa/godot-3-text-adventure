extends ConditionLeaf



func tick(actor, blackboard):
	
	#### IF is_stunned, return Success
	if actor.check_is_stunned():
		
		actor.emit_turn_end_signal()
		return SUCCESS
		
	else:
		return FAILURE
	


