class_name World extends Node2D

var rng: RandomNumberGenerator

# time
var time: float = 0.0
var windSpeedUpdateTime: float = 0.5

# solar
const minSolarPower: float = 0.0
const maxSolarPower: float = 20.0
const solarPowerTimeCycle: float = 90.0

var solarStartPhase: float

# wind
const minWindSpeed: float = 3.0
const maxWindSpeed: float = 17.0
const windSpeedVariation: float = 1.5
const windSpeedVariationMinMaxDelta: float = 3.0

const minDeltaWindSpeedDelta: float = 0.0
const maxDeltaWindSpeedDelta: float = 5.0
const deltaWindSpeedVariation: float = 0.5

var windSpeed: float = 10.0
var deltaWindSpeed: float = 0.75

# resources
var energy: float = 1000
var energyStorage: float = 1000

func _init():
	rng = RandomNumberGenerator.new()
	solarStartPhase = rng.randf()

func _physics_process(dt):
	time += dt
	if fmod(time, windSpeedUpdateTime) < dt:
		var ddWind = rng.randfn(0.0, deltaWindSpeedVariation * windSpeedUpdateTime)
		deltaWindSpeed += ddWind
		deltaWindSpeed = min(max(deltaWindSpeed, \
			minDeltaWindSpeedDelta), \
			maxDeltaWindSpeedDelta)

		var dWind = rng.randfn(0.0, windSpeedVariation * sqrt(deltaWindSpeed) * windSpeedUpdateTime)
		windSpeed += dWind
		windSpeed = min(max(windSpeed, \
			minWindSpeed - windSpeedVariationMinMaxDelta), \
			maxWindSpeed + windSpeedVariationMinMaxDelta)

func getTime():
	return time

func addEnergy(energyGain):
	energy += energyGain
	energy = min(energy, energyStorage)

func removeEnergy(energyCost):
	energy -= energyCost
	assert(energy >= 0, 'world:energy: not enough energy to remove')
	
func getEnergy():
	return energy

func hasEnergy(cost):
	return energy >= cost

func getEnergyStorage():
	return energyStorage

func getWindSpeed():
	return min(max(windSpeed, minWindSpeed), maxWindSpeed)

func getSolarPower():
	return minSolarPower + 0.5 * (maxSolarPower - minSolarPower) * \
	 	(1 + sin(2 * PI * (time / solarPowerTimeCycle + solarStartPhase)))
