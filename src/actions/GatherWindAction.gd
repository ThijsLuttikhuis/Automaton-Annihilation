class_name GatherWindAction extends UnitAction

const gatherWindTime: float = 0.1
const updateAnimationTime: float = 4.0

var efficiency: int
var time: float = 0.0
var totalEnergyGain: float = 0.0

func _init(efficiency_: int = 1):
	efficiency = efficiency_
	isPassive = true
	
func update(unit: Unit, dt):
	time += dt
	if fmod(time, gatherWindTime) < dt:
		var world = unit.player.get_parent()
		var windSpeed = world.getWindSpeed()
		var energyGain = windSpeed * gatherWindTime * efficiency
		world.addEnergy(energyGain)
		
		var newTotalEnergyGain = totalEnergyGain + energyGain
		if fmod(newTotalEnergyGain, updateAnimationTime) < fmod(totalEnergyGain, updateAnimationTime):
			var sprite = unit.get_node("Sprite2D")
			sprite.set_frame((sprite.frame + 1) % sprite.hframes)
		
		totalEnergyGain = newTotalEnergyGain
