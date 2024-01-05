class_name ActionQueue extends Node

var paused: bool = false

var line: Line2D
var lineTestCollisionCount: int = 0
var lineTestCollisionUnits: Array[Unit] = []

var actions: Array[UnitAction]
var passives: Array[UnitAction]

func _ready():
	line = $"ActionPath"
	line.clear_points()
	line.add_point(get_parent().position)

func push_back(values: Array[UnitAction]):
	for value in values:
		if value.isPassive:
			passives.push_back(value)
		else:
			actions.push_back(value)
			line.add_point(value.actionPosition)

func push_front(values: Array[UnitAction]):
	values.reverse()
	for value in values:
		if value.isPassive:
			passives.push_front(value)
		else:
			actions.push_front(value)
			line.add_point(value.actionPosition, 1)
	values.reverse()

func pop_front():
	actions.front().clear()
	actions.pop_front()
	line.remove_point(1)

func get_front():
	if actions.is_empty():
		return null
	return actions.front()

func clear():
	for action in actions:
		action.clear()
	actions.clear()
	line.clear_points()
	line.add_point(get_parent().position)

func update(unit: Unit, dt):
	if !line.points.is_empty():
		line.points[0] = get_parent().position
		
	if paused:
		return
		
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
	
	var action = get_front()
	var completed = action.update(unit, dt)
	if completed:
		pop_front()

func actionsEmpty():
	return actions.is_empty()

func addLineTestCollision(unit):
	if unit is Unit: # || unit is Item:
		lineTestCollisionCount += 1
		lineTestCollisionUnits.push_back(unit)

func removeLineTestCollision(unit):
	if unit is Unit: # || unit is Item:
		lineTestCollisionCount -= 1
		lineTestCollisionUnits.erase(unit)
