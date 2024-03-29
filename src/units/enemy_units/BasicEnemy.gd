class_name BasicEnemy extends FightUnit

func _init():
	moveSpeed = 90
	setMaxHealthPoints(80)
	attackRange = 30
	damage = 10
	selectedActionPriority = -7

func on_ready():
	var world = $"/root/World"
	var target = world.getEnemyTarget()
	var attacktargetAction = AttackTargetAction.new(target)
	actionQueue.push_back([attacktargetAction])

func getDisplayName():
	return "Basic Enemy"
