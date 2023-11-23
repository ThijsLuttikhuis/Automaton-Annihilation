class_name GatherWindAction extends UnitAction

var efficiency: int = 1

func _init(targetPos, efficiency_):
	actionPosition = targetPos
	efficiency = efficiency_
	

func update(unit: Unit):
	pass
