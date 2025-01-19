extends ActionLeaf


func tick(actor, blackboard):
	
	actor.deal_damage(actor.target)	
	return SUCCESS
