class_name ActionQueue extends Node

var actions: Array[UnitAction]
var passives: Array[UnitAction]

func push_back(values: Array[UnitAction]):
	for value in values:
		if value.isPassive:
			passives.push_back(value)
		else:
			actions.push_back(value)

#func pop_back():
#	actions.pop_back();

func push_front(values: Array[UnitAction]):
	values.reverse()
	for value in values:
		actions.push_front(value)
	values.reverse()

#func pop_front():
#	actions.pop_front()

func clear():
	actions.clear()

func update(unit: Unit, dt):
	updatePassives(unit, dt)
	updateActions(unit, dt)

func updatePassives(unit, dt):
	var toErase: Array[UnitAction] = []
	for passive in passives:
		var completed = passive.update(unit, dt)
		if completed:
			toErase.push_back(passive)
			
	for item in toErase:
		actions.erase(toErase)

func updateActions(unit, dt):
	if actions.is_empty():
		return
	
	var action = actions.front()
	var completed = action.update(unit, dt)
	if completed:
		actions.pop_front()
