class_name GatherWindAction extends UnitAction

var efficiency: int = 1
var time: float = 0.0
var gatherWindTime: float = 0.5 # update every 0.5 seconds

func _init(targetPos, efficiency_):
	actionPosition = targetPos
	efficiency = efficiency_
	isPassive = true
	
func update(unit: Unit, dt):
	time += dt
	if time < gatherWindTime:
		return
	
	time -= gatherWindTime
	var world = unit.player.get_parent()
	var windSpeed = world.getWindSpeed()
	var energyGain = windSpeed * gatherWindTime * efficiency
	world.addEnergy(energyGain)
	print("energy: ", world.getEnergy())
