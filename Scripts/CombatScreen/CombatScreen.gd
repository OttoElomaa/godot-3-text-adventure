extends HBoxContainer


onready var combat_log := $Left/Margin/CombatLog
onready var canvas = $Middle/Canvas
onready var info_rows = $Right/Margins/Vbox/InfoRows


signal player_character_finished_turn
signal player_has_selected_target
signal any_animation_has_ended


var BattlerInfo = load("res://Scenes/CombatScreen/BattlerInfoPanel.tscn")


########################

#### ROOM - and the ENCOUNTER from that room
var encounter : Control = null
var current_room = null

onready var combat_2d = $Middle/Canvas/CenterContainer/ViewportContainer/Viewport/Combat2D

#### Setup LISTS for enemy and ally teams
var enemies : Control = null
var party : Node = null

var enemy_group : Array = []
var ally_group : Array = []

var battlers := []

var dead_enemy_list := []

#### Values that INFORM WHAT HAPPENS in the battle
var current_character : Battler = null
var combat_ended := false

var combat_state = States.NONE
var situation = Situations.NONE

var current_input_num = null

#### Manage INPUT state with this
enum States {
	
	NO_ACTION, NONE, ITEMS, SKILLS, VICTORY, PICK_NUM
}

enum Situations {
	
	NONE, ITEMS, SKILLS,
}

var dict_inputs := {}
var dict_enemies_and_sprites := {}


var input_is_ongoing := false


var debug_key1 = null
		
		

func setup_and_fight(room):
	
	current_room = room
	encounter = current_room.encounter
	
	combat_2d.setup(encounter)
	
	dict_inputs["menu_1"] = 1
	dict_inputs["menu_2"] = 2
	dict_inputs["menu_3"] = 3
	dict_inputs["menu_4"] = 4
	dict_inputs["menu_5"] = 5
	dict_inputs["menu_6"] = 6
	dict_inputs["menu_7"] = 7
	dict_inputs["menu_8"] = 8
	dict_inputs["menu_9"] = 9
	
	
	
	
	
	#### The cast of battlers
	var enemy_tab = $Middle/Enemies
	var ally_tab = $Middle/Allies
	
	enemies  = encounter.get_enemies()
	party = DataScene.get_party()
	
	
	#### SETUP AllyList and EnemyList
		
	setup_allies()
	setup_enemies(encounter)
	
	
	#### SETUP Enemy 2D SPRITES
	var sprite_count = 0
	var sprites = combat_2d.get_enemy_sprites()
	for spr in sprites:
		spr.hide()
		
		
	#### SET UP DICTIONARY TO PAIR ENEMIES WITH SPRITES. PUT IN DICT
	for enemy in enemy_group:
		dict_enemies_and_sprites[enemy] = sprites[sprite_count]
		#### AND SETUP
		sprites[sprite_count].get_node("Sprite").texture = enemy.texture
		sprites[sprite_count].show()
		sprite_count += 1
		
		
	#### VISUAL random stuff
	handle_combat_output("Combat begins!", Color.white)
	
	
	#### Start the fight
	for battler in party.get_children():
		battlers.append(battler)
	for battler in enemies.get_children():
		battlers.append(battler)
	
	fight_battle()



func fight_battle():
			
	#### TURN SYSTEM
	while combat_ended == false:
		
		
		#### STATUS AND COOLDOWNS
		#### COUNT DOWN BY ONE TURN. NO OTHER EFFECT
		for battler in battlers:
			if not combat_ended:
				battler.handle_counters()
		
			
		#### LOOP through list of all BATTLERS
		for battler in battlers:
			combat_state = States.NO_ACTION
			if not combat_ended:
				
				#current_character = battler # WHAAATTTT
				var is_enemy : bool = play_battler(battler, battlers)
				
				#### PLAYER ACTIONS
				if not is_enemy:
					if not battler.check_is_stunned():
						combat_state = States.NONE
						yield(self, "player_character_finished_turn")
				#### PLAYER ACTIONS END
				
				
				#### END COMBAT	
				if enemy_group.size() == 0:
					combat_ended = true
			
			#### WAIT FOR ENEMY ACTION ANIMATIONS TO PLAY OUT - SEE ENEMY2D.TSCN
			if battler.is_enemy:
				yield(self, "any_animation_has_ended")
		
		#### APPLY STATUS EFFECTS AT END OF TURN
		for battler in battlers:
			battler.status_handler.apply_status_visual()
			battler.status_handler.apply_status_at_turn_end()
			
		handle_combat_output("_____", Color.wheat)
	
	#### WHEN Combat ENDS	
	combat_state = States.VICTORY
	handle_combat_output("\nYou are victorious!", Color.crimson)
	handle_combat_output("Press F to end combat", Color.white)



func play_battler(battler: Battler, battlers: Array) -> bool:
	
	var is_enemy := false
	print(battler.entity_name)
	
	#### TRY TO run PLAY_TURN function, to run ENEMY AI via BEHAVIOR Tree
	#### IF Battler is ALLY, then you can CONTROL it
	is_enemy = battler.play_turn()	
	if not is_enemy:
		current_character = battler
		
		
	#### AFTER, UPDATE all player health bars visuals
	update_battlers_visuals(battlers)
	info_rows.wipe_history()
	
	#### Return the BOOLEAN to send info about, is it player turn or not
	return is_enemy
	
	

func handle_combat_output(text, color) -> void:		
	
	combat_log.handle_adding_message(text, color)
	
	
	
func handle_combat_info(text, color) -> void:
	
	info_rows.wipe_history()
	info_rows.handle_adding_message(text, color)



func add_combat_info_row(text, color) -> void:

	info_rows.handle_adding_message(text, color)


#### FOR BATTLERINFOPANEL.TSCN
func update_battlers_visuals(battlers: Array) -> void:
	
	#### For EACH Battler, update HEALTH ETC, and STATUS Text
	for battler in battlers:
		battler.update_resource_bars()
		battler.status_handler.apply_status_visual()
	
	
	
func end_player_action():
	combat_state = States.NONE
	input_is_ongoing = false		
	emit_signal("player_character_finished_turn")



func _unhandled_key_input(event):
	
	if combat_state == States.NO_ACTION:
		return
	
	#### IF IN COMBAT, Process this Input
	var parser = DataScene.get_command_parser()
	if parser.game_state == Types.GameStates.COMBAT:
	
		match combat_state:
			
			States.NONE:
				process_command_combat()
				
			States.SKILLS:
				if input_is_ongoing:
					process_command_skills()
					#input_is_ongoing = true
				
			States.ITEMS:
				process_command_items()
				
			States.VICTORY:
				process_command_victory()
			
			States.PICK_NUM:
				process_command_pick_num()
	
	
	
	

func check_key(key_name):
	return Input.is_action_just_pressed(key_name)



func process_command_combat():

	if combat_state == States.NO_ACTION:
		return

	var game_root = DataScene.get_game_root()
	
	#if Input.is_action_just_pressed("CombatFlee"):
	if check_key("CombatFlee"):
		flee(game_root)
	
	
	#### SETS Combat State as SKILLS, WAITS for input	
	elif check_key("combat_skills"):
		
		show_skill_use_info()
			
		#add_combat_info_row(current_character.show_skills(), Color.white)
		
		combat_state = States.SKILLS
		input_is_ongoing = true
	
		
		
	#### SETS Combat State as ITEMS, WAITS for input	
	elif check_key("combat_items"):
		
		info_rows.handle_adding_message("Items info goes here!", Color.white)
		combat_state = States.ITEMS
		
		
	return "It's combat time"



	


func process_command_items():
	
	if combat_state == States.NO_ACTION:
		return
	
	handle_combat_output("AAAAAAAHHHHHHH", Color.cornflower)
	call_deferred("end_player_action")
	
	
	
func process_command_skills():
	
	if combat_state == States.NO_ACTION:
		return
	
	var skills_count = current_character.skills.get_child_count()
	var selected_num = null
	
	var curr = current_character
	var skill = null
	var valid_input_found := false
	
	var all_skills: Array = curr.basic_skills.duplicate()
	all_skills.append_array(curr.special_skills)
	
	#### CHOOSE Skill via INPUT: MATCH INPUT key to SKILL
	for key in dict_inputs.keys():
		debug_key1 = key
		
		#### IF KEY FOUND, AND SKILL IS WITHIN RANGE
		if check_key(key) and skills_count >= dict_inputs[key]:
			selected_num = int(key) - 1
			
			skill = all_skills[selected_num]
			
			if not curr.check_for_cooldown(skill):
				valid_input_found = true
	
	if not valid_input_found:
		return
	
	#### CHOOSE TARGET FOR SKILL USE
	#current_input_num = selected_num

	
	
	curr.target_group = skill.get_target_group(curr)
	show_target_choice_info(curr, curr.target_group,skill)	
	
	combat_state = States.PICK_NUM
	situation = Situations.SKILLS
	yield(self, "player_has_selected_target")
	
	
	#### USE SKILL		
	current_character.skills.get_child(selected_num).activate(current_character)
	call_deferred("end_player_action")



func show_skill_use_info():
	
	#### HANDLE_INFO function calls wipe on the info screen to clear it
	handle_combat_info("Use Skills!", Color.white)
	add_combat_info_row("Current character: %s \n" % current_character.entity_name, Color.white)
	
	var count = 1
	
	for skill in current_character.basic_skills:
		add_combat_info_row("%d: %s \n" % [count, skill.skill_name], Color.white)
		count += 1
		
	for skill in current_character.special_skills:
		
		if current_character.check_for_cooldown(skill):
			var duration = current_character.get_cooldown_duration(skill)
			add_combat_info_row("%d: %s \n(CD: %d) \n" % [count, skill.skill_name, duration], Color.darkgray)
			count += 1
		else:
			add_combat_info_row("%d: %s \n" % [count, skill.skill_name], Color.white)
			count += 1
	


func show_target_choice_info(battler, skill, targetgroup):
	
	handle_combat_info("Choose Target: \n",Color.white)
	
	var num = 1
	for battler in current_character.target_group:
		
		info_rows.handle_adding_message(str(num) + ": " + battler.entity_name + "\n", Color.white)
		current_character.target = battler
		num += 1
		
		

func process_command_pick_num():
	
	match situation:
		
		Situations.SKILLS:
			
			for key in dict_inputs.keys():
				var num = dict_inputs[key] - 1
				
				if check_key(key) and current_character.target_group.size() >= dict_inputs[key]:
					current_character.target = current_character.target_group[num]
					emit_signal("player_has_selected_target")
					return
					
	

func process_command_victory():
	
	var game_root = DataScene.get_game_root()
	
	if check_key("CombatFlee"):
		flee(game_root)
	


func flee(game_root):
	
	game_root.hide_combat_screen()
	current_room.has_combat = false


func emit_combat_ended():
	
	emit_signal("any_animation_has_ended")
	


func setup_allies():
	
	#### Create INFO PANELS for enemies
	var ally_tab = $Middle/Allies
	for ally in party.get_children():
	
		var new_info = BattlerInfo.instance()
		ally_tab.add_child(new_info)
		new_info.setup(ally)
		
		ally_group.append(ally)
		ally.set_as_ally()
	
	
func setup_enemies(encounter):
	
	var enemy_tab = $Middle/Enemies
	
	#### Create INFO PANELS for enemies	
	for enemy in enemies.get_children():
		var new_info = BattlerInfo.instance()
		enemy_tab.add_child(new_info)
		new_info.setup(enemy)
		
		enemy_group.append(enemy)



