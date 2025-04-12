extends Node2D



func setup(encounter):
	
	$Background.texture = encounter.background_texture



func get_enemy_sprites():
	
	return $Enemies2D.get_children()
