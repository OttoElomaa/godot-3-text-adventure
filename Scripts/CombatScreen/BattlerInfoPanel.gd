extends PanelContainer


var battler = null

onready var health_bar = $VBox/HealthBar
onready var mana_bar = $VBox/ManaBar

var health = 0
var max_health = 0

var mana = 0
var max_mana = 0



func setup(new_battler):
	
	battler = new_battler
	$VBox/NamePanel/NameLabel.text = battler.entity_name
	
	#### HEALTH bar
	health = battler.stats.health
	max_health = health
	
	#### MANA bar
	mana = battler.stats.mana
	max_mana = mana
	
	update_resource_bars()
	battler.battler_info_panel = self
	
	
	
func update_resource_bars():
	
	$VBox/StatusRows.wipe_history()
	var count = 0
	for skill in battler.get_skills():
		count = battler.get_cooldown_duration(skill)
		if count != 0:	
			add_status_and_duration(skill.skill_name, count)
	
	battler.status_handler.apply_status_visual()
		#pass
	
	#### HEALTH bar
	health = battler.stats.health
	
	health_bar.value = health
	health_bar.max_value = max_health
	
	$VBox/HealthBar/HealthLabel.text = "%d/%d" % [health, max_health] 
	
	#### MANA bar
	mana = battler.stats.mana
		
	mana_bar.value = mana
	mana_bar.max_value = max_mana
	
	$VBox/ManaBar/ManaLabel.text = "%s/%s" % [str(mana), str(max_mana)] 
	


func add_status_and_duration(text: String, duration: int):
	
	var color = Color.aqua
	
	if text == "Poison":
		color = Color.darkseagreen
	
	$VBox/StatusRows.handle_adding_mini_message("%s: %d" % [text, duration], color)



	
	
	
