class_name DefenseBuilding extends Building

enum TARGET_PRIO {CLOSEST_TO_TARGET, CLOSEST_TO_TOWER, STRONGEST, WEAKEST}
enum DAMAGE_TYPE {INSTANT, PROJECTILE_STRAIGHT, PROJECTILE_PARABOLA}

var targetPrio: TARGET_PRIO = TARGET_PRIO.CLOSEST_TO_TARGET
var enemiesInRange: Array[FightUnit] = []

var time: float = 0.0
var reloadTime: float = 0.0

var damage: float
var fireRate: float
var fireRange: float
var shootEnergyCost: float = 30

var idleAnimationFrame: int = 0
var loadShotAnimationFrames: Array[int] = [0]
var shootAndCooldownAnimationFrames: Array[int] = [0]

func _ready():
	super._ready()
	var collisionShape = $"EnemyTestCollision/CollisionShape2D"
	collisionShape.shape.radius = fireRange

func _physics_process(dt):
	if isGhost():
		return
	
	super._physics_process(dt)
	time += dt
	reloadTime -= dt
	reloadTime = max(reloadTime, 0.0)
	
	updateAnimation()
	
	var targetEnemy = getTargetEnemy()
	if !targetEnemy || reloadTime > 0:
		return
	
	if !player.world.hasEnergy(shootEnergyCost):
		return
	
	player.world.removeEnergy(shootEnergyCost)
	shoot(targetEnemy)
	reloadTime = 1.0 / fireRate

func updateAnimation():
	var sprite = $"Sprite2D"
	if !getTargetEnemy() && reloadTime < 0.02:
		sprite.frame = idleAnimationFrame;
		return
	
	var remainingFractionToFire = reloadTime * fireRate
	var totalFrames = float(loadShotAnimationFrames.size() + shootAndCooldownAnimationFrames.size())
	var frame = floor((totalFrames - 0.1) - remainingFractionToFire * (totalFrames - 0.1))
	
	if shootAndCooldownAnimationFrames.size() > frame:
		sprite.frame = shootAndCooldownAnimationFrames[frame]
	else:
		sprite.frame = loadShotAnimationFrames[frame - shootAndCooldownAnimationFrames.size()]

func shoot(_targetEnemy: FightUnit):
	pass # to be overwritten

func getTargetEnemy():
	if enemiesInRange.is_empty():
		return null
	
	var targetEnemy = enemiesInRange[0]
	for enemy in enemiesInRange:
		if isBetterEnemy(enemy, targetEnemy):
			targetEnemy = enemy
	
	return targetEnemy

func isBetterEnemy(enemy: FightUnit, compareTo: FightUnit):
	if targetPrio == TARGET_PRIO.CLOSEST_TO_TOWER:
		return (enemy.position - position).length_squared() < \
			(compareTo.position - position).length_squared()
	
	if targetPrio == TARGET_PRIO.CLOSEST_TO_TARGET:
		var enemyTarget = player.world.getEnemyTarget()
		return (enemy.position - enemyTarget.position).length_squared() < \
			(compareTo.position - enemyTarget.position).length_squared()
	
	if targetPrio == TARGET_PRIO.STRONGEST:
		return enemy.healthPoints > compareTo.healthPoints
	
	if targetPrio == TARGET_PRIO.WEAKEST:
		return enemy.healthPoints < compareTo.healthPoints

func addUnit(unit):
	if ghost:
		return
	if unit is FightUnit && unit.isEnemy():
		enemiesInRange.push_back(unit)

func removeUnit(unit):
	if unit is FightUnit:
		if enemiesInRange.find(unit) != -1:
			enemiesInRange.erase(unit)
