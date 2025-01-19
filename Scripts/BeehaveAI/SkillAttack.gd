extends ActionLeaf

var actor = null

func tick(actor, blackboard):
	
	self.actor = actor
	
	match actor.skill_type:
		
		actor.enum_skill_types.BasicAttack:
			basic_attack()
	
		actor.enum_skill_types.BasicHeal:
			basic_heal()




func basic_attack():
	actor.deal_damage(actor.target)	
	return SUCCESS
	
func basic_heal():
	
	actor.heal(actor.target)
