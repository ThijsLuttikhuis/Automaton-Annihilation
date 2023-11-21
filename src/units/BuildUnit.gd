class_name BuildUnit extends Unit

var buildPower: float
var buildRange: float
#var buildList: BuildList

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			#TODO: other actions than move -- check mouse click location / selected building / ... 
			
			var targetPosition = get_viewport().get_camera_2d().get_global_mouse_position()
			var action = MoveAction.new(targetPosition)
			
			var aq = get_node("ActionQueue")
			if Input.is_action_pressed("ui_push_back_queue"):
				aq.push_back(action)
			elif Input.is_action_pressed("ui_push_front_queue"):
				aq.push_front(action)
			else:
				aq.clear()
				aq.push_back(action)
