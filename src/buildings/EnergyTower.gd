class_name EnergyTower extends DefenseBuilding

@onready var laserShoot: LaserShoot = $"LaserShoot"

func _init():
	energyCost = 100
	resourceCost.add('Iron Plate', 4)
	resourceCost.add('Copper Plate', 4)
	
	healthPoints = 300
	damage = 50
	fireRate = 0.5
	fireRange = 70
	
	idleAnimationFrame = 3
	loadShotAnimationFrames = [1, 2, 3]
	shootAndCooldownAnimationFrames = [4, 5, 6]

func shoot(targetEnemy: FightUnit):
	laserShoot.shoot(self, targetEnemy)

func getDisplayName():
	return "Energy Tower"

func getShootPosition():
	return position + Vector2(0, -20)
