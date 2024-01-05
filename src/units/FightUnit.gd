class_name FightUnit extends MoveUnit

var isEnemyUnit: bool = true

var time: float
var reloadTime: float

var damage: float
var attackRate: float
var attackRange: float

func isEnemy():
	return isEnemyUnit

func isAlly():
	return !isEnemyUnit
