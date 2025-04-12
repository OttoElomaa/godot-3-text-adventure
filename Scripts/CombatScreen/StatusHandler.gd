extends Node2D




var rng = RandomNumberGenerator.new()

var has_poison = false
var poison_counter = null

var battler = null
var combat = null

var cooldown_counters := []
var status_counters := []


var status_text = ""



func _ready():
	pass
	
	
	
func setup():
	
	battler = get_parent()
	combat = DataScene.get_combat_screen()
	
	

#### COUNT DOWN BY ONE TURN. NO OTHER EFFECT
func play_counters_turn():
	
	for co in cooldown_counters:
		co.take_turn()
	for co in status_counters:
		co.take_turn()

	
	
	

#### COUNTER CREATION Moved From Enemy FROM OTHER PROJECT
func add_counter_help():
	
	var Counter = preload("res://Scenes/CombatScreen/Counter.tscn")
	var counter = Counter.instance()
	add_child(counter)
	
	return counter
	
	
func add_cooldown_counter(skill):

	var counter = add_counter_help()
	cooldown_counters.append(counter)
	counter.counter_init(self, skill, "cooldown")
	
	
func add_status_counter(skill):

	var counter = add_counter_help()
	status_counters.append(counter)
	counter.counter_init(self, skill, "status")
	
	remove_duplicate_counters(counter)
	apply_status_visual()
	

##################### Counter CREATION END



func remove_duplicate_counters(counter):
	
	#var counters = status_counters
	var types_n_counters := {}
	var cou = counter
	#for cou in counters:
		
	var effect = cou.status_effect
	var duplicate_found = false
	
	for type in types_n_counters.keys():
		if type == effect:
			
			if cou.counter_turns >= types_n_counters[effect].counter_turns:
				types_n_counters[effect] = cou
			else:
				duplicate_found = true
			
	if not duplicate_found:
		types_n_counters[effect] = cou


"""
func play_animations():
	
	$AnimationPlayer.playback_active = true
	
	if has_poison:
		
		$StatusPoisonSprite.visible = true
		$AnimationPlayer.play("StatusPoison")
"""


func apply_status_visual():
	
	if not is_instance_valid(battler):
		return
	
	var info_panel = battler.battler_info_panel
	
	#### GO through the STATUS LIST
	for counter in status_counters:
		if is_instance_valid(counter):
			
			var color = null
			
			var status_enum = counter.get_status_enum()
			match counter.status_effect:
				
				status_enum.POISON:
					color = Color.darkseagreen
					info_panel.add_status_and_duration(counter.skill.status_effect_str, counter.counter_turns, color)
				
				status_enum.STUN:
					color = Color.lightsalmon
					info_panel.add_status_and_duration(counter.skill.status_effect_str, counter.counter_turns, color)
				

	
func apply_status_initial():
	pass
	
	
	
func apply_status_at_turn_end():
	
	for counter in status_counters:
		if is_instance_valid(counter):
			
			#### Check if MULTIPLE effects of same type at once >> Longest timer wins
			var status_enum = counter.get_status_enum()
			match counter.status_effect:
				
				status_enum.POISON:
					var damage = counter.skill.status_amount
					var text = "\n%s takes %d poison damage!" % [battler.entity_name, damage]
					var color = Color.darkseagreen
					
					battler.deal_indirect_damage(battler, damage)
					combat.handle_combat_output(text, color)
					print("IIIMMM POIUSONEEEEDDDDDDD")
					



func check_is_stunned() -> bool:
	
	for counter in status_counters:
		if is_instance_valid(counter):
	
			var status_enum = counter.get_status_enum()
			match counter.status_effect:
						
				status_enum.STUN:
					return true
			
	return false

