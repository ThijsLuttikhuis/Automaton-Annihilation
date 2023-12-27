class_name AttackTargetAction extends UnitAction

var attackCooldown: float = 1.0
var remainingCooldown: float = 0.0

var moveAction: MoveAction
var targetUnit: Unit

func _init(targetUnit_: Unit):
	targetUnit = targetUnit_

func update(unit: Unit, dt):
	remainingCooldown -= dt
	var attackRangeSquared =  unit.attackRange * unit.attackRange
	actionPosition = targetUnit.position
	if attackRangeSquared < (unit.position - actionPosition).length_squared():
		if moveAction:
			moveAction.actionPosition = actionPosition
			moveAction.update(unit, dt)
		else:
			moveAction = MoveAction.new(actionPosition)
	elif remainingCooldown <= 0.0: # attack!
		targetUnit.removeHP(unit.damage)
		remainingCooldown = attackCooldown
