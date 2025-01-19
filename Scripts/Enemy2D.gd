extends StaticBody2D


onready var attack_sprite := $AttackSprite


func _ready():
	
	attack_sprite.hide()


func play_anim_attack():
	
	attack_sprite.show()
	$AnimSplashes.play("MeleeStrike")
	$Animations.play("Attack")
	


func animation_ended():
	
	attack_sprite.hide()
	var combat = DataScene.get_combat_screen()
	combat.emit_combat_ended()
