class_name GatherWindAction extends UnitAction

var efficiency: int = 1
var time: float = 0.0
var gatherWindTime: float = 0.5

func _init(efficiency_):
	efficiency = efficiency_
	isPassive = true
	
func update(unit: Unit, dt):
	time += dt
	if fmod(time, gatherWindTime) < dt:
		var world = unit.player.get_parent()
		var windSpeed = world.getWindSpeed()
		var energyGain = windSpeed * gatherWindTime * efficiency
		world.addEnergy(energyGain)
