extends Node2D


###########################################
#### A Counter! For storing effects that last a turn or longer




#### TYPE: declare if it's a status effect for a creature, or a cooldown for a skill
var cooldown := false
var status = false

var battler = null

#### THE amount of turns till it expires.
var counter_turns = 0


#### THE associated skill or effect.
var skill: Node = null
var status_effect = null
var status_effect_str := ""
	

func counter_init(battler, skill_input, type):

	
	skill = skill_input
	self.battler = battler
	
	#### DIFFERENT operation mechanisms for STATUS and COOLDOWN counters
	if type == "status":
		
		status = true
		counter_turns = skill.status_duration + 1
		status_effect = skill.status_effect
		status_effect_str = skill.status_effect_str
		
	elif type == "cooldown":
		
		cooldown = true
		counter_turns = skill.cooldown + 1
	
		
	

#### THIS function is linked to the game TURN SIGNAL from PLAYER
#### So EVERY COUNTER ticks when player takes a turn

func take_turn():
		
	counter_turns -= 1
	
	#### COUNTER is DESTROYED when turns counter hits zero.	
	if counter_turns <= 0:
		
		remove_counter()
		self.queue_free()
		
		
	
	

func remove_counter():
	
	var status_h = get_parent()
	
	if status:
		status_h.status_counters = remove_counter_from_list(status_h.status_counters)
		
	elif cooldown:
		status_h.cooldown_counters = remove_counter_from_list(status_h.cooldown_counters)
		
		

func remove_counter_from_list(list):
	
	var temp_list = []	
	for c in list:
		if not c == self:
			if is_instance_valid(c):
				temp_list.append(c)
			
	return temp_list.duplicate()
		
		
		
		
func cooldown_turn():
	pass
	

func status_turn():
	pass











