class_name BasicEnemy extends FightUnit

func _init():
	moveSpeed = 150
	setMaxHealthPoints(200)
	
	selectedActionPriority = -7

func on_ready():
	var world = $"/root/World"
	var target = world.getEnemyTarget()
	var attacktargetAction = AttackTargetAction.new(target)
	actionQueue.push_back([attacktargetAction])

func getDisplayName():
	return "Basic Enemy"
