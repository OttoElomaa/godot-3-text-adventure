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



#### COUNTER CREATION Moved From Enemy FROM OTHER PROJECT
func add_counter_help():
	
	var Counter = preload("res://ScenesMisc/Counter.tscn")
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

##################### Counter CREATION END


func play_animations():
	
	$AnimationPlayer.playback_active = true
	
	if has_poison:
		
		$StatusPoisonSprite.visible = true
		$AnimationPlayer.play("StatusPoison")



func apply_status():
	
	$AnimationPlayer.stop()
	$StatusPoisonSprite.visible = false
	
	
	has_poison = false
	poison_counter = null
	
	status_text = ""
	 
	
	#### GO through the STATUS LIST
	for counter in status_counters:
		
		if is_instance_valid(counter):
			
			#### CHECK FOR every type of status
			if counter.status_effect == "poison":
				
				has_poison = true
				#### Check if MULTIPLE effects of same type at once >> Longest timer wins
				poison_counter = compare_counters(counter, poison_counter)
				
				
				
	apply_poison(poison_counter)
	
	play_animations()
	
	#### STATUS TEXT is filled in apply_poison() etc, now pass it to interface
	#interface.manage_status_log( status_text )


#### COMPARES counters to select the one with HIGHEST TURN count left
func compare_counters( new_counter, old_counter ):
	
	if old_counter == null:
		old_counter = new_counter
	elif is_instance_valid(old_counter) == false:
		old_counter = new_counter
	elif new_counter.counter_turns > old_counter.counter_turns:
		old_counter = new_counter
		
	return old_counter


				
func apply_poison(counter):
	
	#$AnimationPlayer.play("RESET")
	
	if has_poison:
		
		var poison_damage = rng.randi_range(1,2)
		#data_layer.deal_indirect_damage(poison_damage,character)
		
		var status_str = "The %s  takes %s poison damage! (%s) \n" % [
			battler.unit_name, poison_damage, counter.counter_turns]
		
		status_text += status_str








