class_name World extends Node2D

var energy: float = 0
var energyStorage: float = 1000

func addEnergy(energyGain):
	energy += energyGain
	energy = min(energy, energyStorage)

func getEnergy():
	return energy

func getWindSpeed():
	return round(10.2)
	#TODO: make random windspeed func

