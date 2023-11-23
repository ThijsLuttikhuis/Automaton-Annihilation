class_name ActionQueue extends Node

var actions: Array[UnitAction]

func push_back(values: Array[UnitAction]):
	for value in values:
		actions.push_back(value)

func pop_back():
	actions.pop_back();

func push_front(values: Array[UnitAction]):
	values.reverse()
	for value in values:
		actions.push_front(value)
	values.reverse()

func pop_front():
	actions.pop_front()

func clear():
	actions.clear()

func update(unit: Unit):
	if actions.is_empty():
		return
	
	var currentAction = actions.front()
	var completed = currentAction.update(unit)
	if completed:
		pop_front()
