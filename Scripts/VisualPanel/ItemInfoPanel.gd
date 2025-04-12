extends PanelContainer



func setup(item:Node):
	
	$MarginContainer/HBox/NameVBox/NameLabel.text = item.item_name
	$MarginContainer/HBox/NameVBox/IdLabel.text = item.item_id
	$MarginContainer/HBox/SellPriceLabel.text = "%d" % item.sell_price
	
	
	var icon = $MarginContainer/HBox/ItemIcon
	var descLabel = $MarginContainer/HBox/DescriptionLabel
	
	match item.item_type:
		
		"key":
			icon.texture = load("res://Sprites/inventory-icon-key.png")
			descLabel.text = "Key: Opens a door somewhere."
			
		"food":
			icon.texture = load("res://Sprites/inventory-icon-food-v2.png")
			descLabel.text = "Food: Recovers %d hunger points." % item.use_value
