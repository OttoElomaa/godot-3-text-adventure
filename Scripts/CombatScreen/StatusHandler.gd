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
	
	


func play_counters_turn():
	
	for co in cooldown_counters:
		co.take_turn()
	for co in status_counters:
		co.take_turn()

	apply_status_visual()
	
	

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



func play_animations():
	
	$AnimationPlayer.playback_active = true
	
	if has_poison:
		
		$StatusPoisonSprite.visible = true
		$AnimationPlayer.play("StatusPoison")



func apply_status_visual():
	
	#$AnimationPlayer.stop()
	#$StatusPoisonSprite.visible = false
	#status_text = ""
	
	var info_panel = battler.battler_info_panel
	
	#### GO through the STATUS LIST
	for counter in status_counters:
		
		if is_instance_valid(counter):
			
			#### CHECK FOR every type of status
			if counter.status_effect_str == "Poison":
				
				info_panel.add_status_and_duration(counter.skill.status_effect_str, counter.counter_turns)
				print("IIIMMM POIUSONEEEEDDDDDDD")
				
				#### Check if MULTIPLE effects of same type at once >> Longest timer wins
			
				
				
				
	#apply_poison(poison_counter)
	
	#play_animations()
	







