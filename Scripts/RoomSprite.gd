extends Sprite


var room = null


func hide_exits():
	
	$NorthExit.hide()
	$SouthExit.hide()
	$WestExit.hide()
	$EastExit.hide()


func draw_exit(dir_str):
	
	match dir_str:
		"north":
			$NorthExit.show()
		"south":
			$SouthExit.show()
		"west":
			$WestExit.show()
		"east":
			$EastExit.show()
