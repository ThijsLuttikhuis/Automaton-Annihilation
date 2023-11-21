extends TileMap

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			var mousePos = get_viewport().get_camera_2d().get_global_mouse_position()
			var clickedCellIndex = local_to_map(mousePos)
			print("clicked WorldTileMap: ", clickedCellIndex)
			var data = get_cell_tile_data(1, clickedCellIndex)
			if data:
				print(data)
	
	if event is InputEventMouseMotion:
		var mousePos = get_viewport().get_camera_2d().get_global_mouse_position()
		var clickedCellIndex = local_to_map(mousePos)
		print("hovering WorldTileMap: ", clickedCellIndex)
		var data = get_cell_tile_data(1, clickedCellIndex)
		if data:
			print(data)
				
