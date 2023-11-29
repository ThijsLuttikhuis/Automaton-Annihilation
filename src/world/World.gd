class_name World extends Node2D

var rng: RandomNumberGenerator

# time
var time: float = 0.0
var windSpeedUpdateTime: float = 0.5

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
var energy: float = 0
var energyStorage: float = 1000

func _init():
	rng = RandomNumberGenerator.new()

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

func addEnergy(energyGain):
	energy += energyGain
	energy = min(energy, energyStorage)

func getEnergy():
	return energy

func getEnergyStorage():
	return energyStorage

func getWindSpeed():
	return min(max(windSpeed, minWindSpeed), maxWindSpeed)
