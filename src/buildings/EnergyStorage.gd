class_name EnergyStorage extends Building

const frameCycleTimeWhenFull: float = 1.2

var frameCycle: float = 0.0

func _init():
	energyStorage = 3000

	energyCost = 200
	resourceCost.add('Iron Plate', 2)
	resourceCost.add('Copper Plate', 5) # to be copper wire

func _physics_process(dt):
	if isGhost():
		return
	
	var sprite = $"Sprite2D"
	var fillLevel = player.world.getEnergy() / player.world.getEnergyStorage()
	frameCycle += sprite.hframes * fillLevel * dt / frameCycleTimeWhenFull
	frameCycle = fmod(frameCycle, float(sprite.hframes))
	sprite.frame = floor(frameCycle)

func getDisplayName():
	return "Energy Storage"
