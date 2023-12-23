class_name EnergyTower extends DefenseBuilding

func _init():
	energyCost = 100
	resourceCost.add('Iron Plate', 4)
	resourceCost.add('Copper Plate', 4)
	
	healthPoints = 300
	damage = 50
	fireRate = 0.5
	fireRange = 50
	
	idleAnimationFrame = 0
	loadShotAnimationFrames = [1, 2, 3]
	shootAndCooldownAnimationFrames = [4, 5, 6]
	
func getDisplayName():
	return "Energy Tower"

