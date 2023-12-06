class_name GatherSolarAction extends UnitAction

var efficiency: int
var time: float = 0.0
var gatherSolarTime: float = 0.5

func _init(efficiency_: int = 1):
	efficiency = efficiency_
	isPassive = true
	
func update(unit: Unit, dt):
	time += dt
	if fmod(time, gatherSolarTime) < dt:
		var world = unit.player.get_parent()
		var solarPower = world.getSolarPower()
		var energyGain = solarPower * gatherSolarTime * efficiency
		world.addEnergy(energyGain)
		
		var sprite = unit.get_node("Sprite2D")
		sprite.set_frame(floor(3.999 - solarPower / 5.01))
