extends ActionLeaf

var actor = null

func tick(actor, blackboard):
	
	self.actor = actor
	actor.handle_skill_use_info()
	var target = actor.target
	
	
	match actor.skill_type:
		
		actor.enum_skill_types.BasicAttack:
			basic_attack()
	
		actor.enum_skill_types.BasicHeal:
			basic_heal()
	
	
	if actor.has_status_effect:
		add_status(actor, target)
	
	
	#### PUT Skill on COOLDOWN IF NECESSARY (Value 0 Means NO COOLDOWN)		
	if actor.cooldown > 0:
		actor.battler.put_skill_on_cooldown(actor)



func basic_attack():
	actor.deal_damage(actor.target)	
	return SUCCESS
	
	
func basic_heal():
	actor.heal(actor.target)


func add_status(skill, target):
	
	target.add_status_counter(skill)

