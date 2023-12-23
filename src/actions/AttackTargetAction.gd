class_name AttackTargetAction extends UnitAction

var moveAction: MoveAction
var targetUnit: Unit

func _init(targetUnit_: Unit):
	targetUnit = targetUnit_

func update(unit: Unit, dt):
	actionPosition = targetUnit.position
	if unit.attackRange * unit.attackRange < (unit.position - actionPosition).length_squared():
		if moveAction && moveAction.actionPosition == actionPosition:
			moveAction.update(unit, dt)
		else:
			moveAction = MoveAction.new(actionPosition)
	else:
		pass # attack
