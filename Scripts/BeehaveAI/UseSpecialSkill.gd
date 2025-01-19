extends ActionLeaf




func tick(actor, blackboard):

	var combat = DataScene.get_combat_screen()
	#combat.handle_combat_output(actor.entity_name + " takes its turn!", Color.white)
	
	#### SKILLS have their own Behavior Tree!
	for skill in actor.special_skills:
		
		if not actor.check_for_cooldown(skill):
			blackboard.set("skill_to_use", skill)
			return SUCCESS
	
		combat.handle_combat_output("\n%s can't use %s due to cooldown" % [
			actor.entity_name,skill.skill_name], Color.darkgray)
	return FAILURE
