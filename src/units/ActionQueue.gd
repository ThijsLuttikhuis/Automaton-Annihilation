class_name ActionQueue extends Node

var actions: Array[UnitAction]
var line: Line2D

func _ready():
	line = get_node("ActionPath")
	line.clear_points()
	line.add_point(get_parent().position)

func push_back(values: Array[UnitAction]):
	for value in values:
		actions.push_back(value)
		line.add_point(value.actionPosition)

func pop_back():
	actions.pop_back();

func push_front(values: Array[UnitAction]):
	values.reverse()
	for value in values:
		actions.push_front(value)
		line.add_point(value.actionPosition, 1)
	values.reverse()
	
func pop_front():
	actions.pop_front()
	line.remove_point(1)

func clear():
	actions.clear()
	line.clear_points()
	line.add_point(get_parent().position)

func update(unit: Unit):
	line.points[0] = get_parent().position
	if actions.is_empty():
		return
	
	var currentAction = actions.front()
	var completed = currentAction.update(unit)
	if completed:
		pop_front()
