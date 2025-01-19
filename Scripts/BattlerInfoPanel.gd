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
	
	
	
	
