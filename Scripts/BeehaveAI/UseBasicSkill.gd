extends ActionLeaf




func tick(actor, blackboard):

	var combat = DataScene.get_combat_screen()
	#combat.handle_combat_output(actor.entity_name + " takes its turn!", Color.white)
	
	#### SKILLS have their own Behavior Tree!
	for skill in actor.basic_skills:
		blackboard.set("skill_to_use", skill)
		return SUCCESS
	
	return FAILURE
