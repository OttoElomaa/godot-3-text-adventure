extends HBoxContainer


onready var combat_log := $Left/Margin/CombatLog
onready var canvas = $Middle/Canvas
onready var info_rows = $Right/Margins/Vbox/InfoRows


signal player_character_finished_turn


var BattlerInfo = load("res://ScenesMisc/BattlerInfoPanel.tscn")


########################

#### ROOM - and the ENCOUNTER from that room
var encounter : Control = null
var current_room = null

#### Setup LISTS for enemy and ally teams
var enemies : Control = null
var party : Node = null

var enemy_group : Array = []
var ally_group : Array = []

var battlers := []

var dead_enemy_list := []

#### Values that INFORM WHAT HAPPENS in the battle
var current_character : Battler = null
var combat_state = States.NONE
var combat_ended := false


#### Manage INPUT state with this
enum States {
	
	NONE, ITEMS, SKILLS, VICTORY
}

		

func setup_and_fight(room):
	
	current_room = room
	
	#### Scuffy way of moving the encounter HERE to use it for combat
	encounter = current_room.get_node("CombatEncounter")
	current_room.remove_child(current_room.get_node("CombatEncounter"))
	canvas.add_child(encounter)
	
	#### The cast of battlers
	var enemy_tab = $Middle/Enemies
	var ally_tab = $Middle/Allies
	
	enemies  = encounter.get_enemies()
	party = DataScene.get_party()
	
	setup_allies()
	setup_enemies(encounter)
	
	#### VISUAL random stuff
	handle_combat_output("Combat begins!", Color.white)
	
	
	#### Start the fight
	for battler in party.get_children():
		battlers.append(battler)
		
	for battler in enemies.get_children():
		battlers.append(battler)
	
		
		
	#### TURN SYSTEM
		
	while combat_ended == false:
		
		#### LOOP through list of all BATTLERS
		for battler in battlers:
			
			if combat_ended == false:
				
				current_character = battler # WHAAATTTT
				var is_player : bool = play_battler(battler, battlers)
				
				if is_player:
					yield(self, "player_character_finished_turn")
			
				for battler2 in battlers:
					battler2.update_resource_bars()
				
				#### END COMBAT	
				if enemy_group.size() == 0:
					combat_ended = true
	
	#### WHEN Combat ENDS	
	combat_state = States.VICTORY
	handle_combat_output("\nYou are victorious!", Color.crimson)
	handle_combat_output("Press F to end combat", Color.white)

	

func play_battler(battler: Battler, battlers: Array) -> bool:
	
	handle_combat_output("\n" + battler.entity_name + " takes its turn!", Color.white)
	
	var is_player = false
	
	#### IDK. TEST IF NULL?
	if battler == null:
		assert(1 == 2)
		return is_player
		
	#### IF Battler is ALLY, then you can CONTROL it
	#### Set is-player BOOLEAN, and set CURRENT_CHARACTER value
	if battler.is_enemy == false:
		current_character = battler
		print(battler.entity_name)
		is_player = true
	
	
	#### ELSE, play the Enemy PLAY_TURN function 
	#### to run its AI via BEHAVIOR Tree			
	else:
		battler.play_turn()
		print(battler.entity_name)
	
	
	#### AFTER, UPDATE all player health bars visuals
	#if enemy_group.size() > 0:
	update_battlers_visuals(battlers)
	
	
	
	#### Return the BOOLEAN to send info about, is it player turn or not
	return is_player
	

func handle_combat_output(text, color) -> void:		
	
	combat_log.handle_adding_message(text, color)
	
	
func handle_combat_info(text, color) -> void:
	
	info_rows.wipe_history()
	info_rows.handle_adding_message(text, color)



func update_battlers_visuals(battlers: Array) -> void:
	
	for battler in battlers:
		battler.update_resource_bars()
	
	
func end_player_action():
	combat_state = States.NONE		
	emit_signal("player_character_finished_turn")



func _unhandled_key_input(event):
	
	#### IF IN COMBAT, Process this Input
	var parser = DataScene.get_command_parser()
	if parser.game_state == Types.GameStates.COMBAT:
	
		match combat_state:
			
			States.NONE:
				process_command_combat()
				
			States.SKILLS:
				process_command_skills()
				
			States.ITEMS:
				process_command_items()
				
			States.VICTORY:
				process_command_victory()



func check_key(key_name):
	return Input.is_action_just_pressed(key_name)
	

func process_command_items():
	
	handle_combat_output("AAAAAAAHHHHHHH", Color.cornflower)
	call_deferred("end_player_action")
	
	
func process_command_skills():
	
	#handle_combat_output("AAAAAAAHHHHHHH", Color.webgreen)
	var skills_count = current_character.skills.get_child_count()
	
	if check_key("menu_1") and skills_count >= 1:
		current_character.skills.get_child(0).activate(current_character)
		call_deferred("end_player_action")

	
	if check_key("menu_2") and skills_count >= 2:
		current_character.skills.get_child(1).activate(current_character)
		call_deferred("end_player_action")
	
	
func process_command_combat():

	var game_root = DataScene.get_game_root()
	
	#if Input.is_action_just_pressed("CombatFlee"):
	if check_key("CombatFlee"):
		flee(game_root)
		
	elif check_key("combat_skills"):
		
		#### HANDLE_INFO function calls wipe on the info screen to clear it
		handle_combat_info("Skills info goes here!", Color.white)
		info_rows.handle_adding_message("Current character: " + current_character.entity_name, Color.white)
		
		info_rows.handle_adding_message(current_character.show_skills(), Color.white)
		combat_state = States.SKILLS
		
		
	elif check_key("combat_items"):
		
		info_rows.handle_adding_message("Items info goes here!", Color.white)
		combat_state = States.ITEMS
		
		
	return "It's combat time"


func process_command_victory():
	
	var game_root = DataScene.get_game_root()
	
	if check_key("CombatFlee"):
		flee(game_root)
	


func flee(game_root):
	
	game_root.hide_combat_screen()
	current_room.has_combat = false


func setup_allies():
	
	#### Create INFO PANELS for enemies
	var ally_tab = $Middle/Allies
	for ally in party.get_children():
	
		#ally.get_node("Texture").hide()
		var new_info = BattlerInfo.instance()
		ally_tab.add_child(new_info)
		new_info.setup(ally)
		
		ally_group.append(ally)
		ally.set_as_ally()
	
	
func setup_enemies(encounter):
	
	var enemy_tab = $Middle/Enemies
	
	#### PLACE enemy Sprites VISUALLY on the screen
	place_enemy_sprites(encounter, true)
	
	#### Create INFO PANELS for enemies	
	for enemy in enemies.get_children():
		var new_info = BattlerInfo.instance()
		enemy_tab.add_child(new_info)
		new_info.setup(enemy)
		
		enemy_group.append(enemy)


#enemy.get_node("Texture").rect_global_position = pos.rect_global_position

func place_enemy_sprites(encounter, is_initial):
	
	var positions = [Vector2(0.5, 0.8), Vector2(0.1, 0.8), Vector2(0.9, 0.8), 
	Vector2(0.5, 0.3), Vector2(0.2, 0.3), Vector2(0.8, 0.3)]
	
	#### PLACE enemy Sprites VISUALLY on the screen
	var placement_count = 0
	for enemy in enemies.get_children():
		
		var sprite = enemy.get_node("Texture")
		var texture_rect = encounter.get_texture()
		var background_pos = texture_rect.rect_global_position
		sprite.rect_global_position = background_pos + texture_rect.rect_size * positions[placement_count]

		#### For UNKNOWN reason it acts differently on screen Resize
		if is_initial == false:
			sprite.rect_global_position += Vector2(-50, -100)

		placement_count += 1



func _on_Canvas_resized():
	
	#self.visible = false
	#self.call_deferred("set_visible", true)
	#yield(get_tree(),"idle_frame") # yield until the next idle frame
	place_enemy_sprites(encounter, false)
