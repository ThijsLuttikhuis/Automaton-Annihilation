class_name ActionQueue extends Node

var actions: Array[UnitAction]
var line: Line2D

func _ready():
	line = get_node("ActionPath")
	line.clear_points()
	line.add_point(get_parent().position)

func push_back(value: UnitAction):
	actions.push_back(value)
	line.add_point(value.actionPosition)

func pop_back():
	actions.pop_back();

func push_front(value: UnitAction):
	actions.push_front(value)
	line.add_point(value.actionPosition, 1)

func pop_front():
	actions.pop_front()
	line.remove_point(1);

func clear():
	actions.clear()
	line.clear_points()
	line.add_point(get_parent().position)

func update(unit: Unit):
	line.points[0] = get_parent().position
	if actions.is_empty():
		return
	
	var currentAction = actions.front()
	var completed = currentAction.update(unit);
	if completed:
		pop_front()
