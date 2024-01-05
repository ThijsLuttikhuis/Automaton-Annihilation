class_name World extends Node2D

@onready var gameOverScene = load("res://src/ui/GameOver.tscn")
@onready var architect: Architect = $"Units/Architect"
@onready var tileMap: WorldTileMap = $"WorldTileMap"

var rng: RandomNumberGenerator

# time
var time: float = 0.0
const tickTime: float = 0.5

# solar
const minSolarPower: float = 0.0
const maxSolarPower: float = 20.0
const solarPowerTimeCycle: float = 90.0

var solarStartPhase: float

# wind
var minWindSpeed: float = 3.0
var maxWindSpeed: float = 17.0
const windSpeedVariation: float = 1.5
const windSpeedVariationMinMaxDelta: float = 3.0

const minDeltaWindSpeedDelta: float = 0.0
const maxDeltaWindSpeedDelta: float = 5.0
const deltaWindSpeedVariation: float = 0.5

var windSpeed: float = 10.0
var deltaWindSpeed: float = 0.75

# resources
var defaultEnergyStorage: float = 1000.0
var energy: float = 0.0
var energyStorage: float = defaultEnergyStorage

var difficulty: int = 0

func _init():
	rng = RandomNumberGenerator.new()
	solarStartPhase = rng.randf()

func _physics_process(dt):
	time += dt
	if fmod(time, tickTime) < dt:
		updateWindSpeed()
		updateEnergyStorage()

func updateWindSpeed():
	var ddWind = rng.randfn(0.0, deltaWindSpeedVariation * tickTime)
	deltaWindSpeed += ddWind
	deltaWindSpeed = min(max(deltaWindSpeed, \
		minDeltaWindSpeedDelta), \
		maxDeltaWindSpeedDelta)

	var dWind = rng.randfn(0.0, windSpeedVariation * sqrt(deltaWindSpeed) * tickTime)
	windSpeed += dWind
	windSpeed = min(max(windSpeed, \
		minWindSpeed - windSpeedVariationMinMaxDelta), \
		maxWindSpeed + windSpeedVariationMinMaxDelta)

func updateEnergyStorage():
	var buildings = $"Buildings".get_children()
	var totalEnergy = defaultEnergyStorage
	for building in buildings:
		totalEnergy += building.energyStorage
	energyStorage = totalEnergy

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

func getBuildings(buildingDisplayName: String = ""):
	if buildingDisplayName == "":
		return $"Buildings".get_children()
	
	var buildingsCorrectType: Array = []
	for building in $"Buildings".get_children():
		if building.getDisplayName() == buildingDisplayName:
			buildingsCorrectType.push_back(building)
	
	return buildingsCorrectType


func getBuildingFromPosition(position: Vector2) -> Building:
	var cellI = tileMap.local_to_map(position)
	return getBuildingFromCellI(cellI)
	
func getBuildingFromCellI(cellI: Vector2i) -> Building:
	var tileData = tileMap.get_cell_tile_data(2, cellI)
	if !tileData:
		return null
	
	var buildingName = tileData.get_custom_data("buildingName")
	var buildingsWithName = getBuildings(buildingName)
	for building in buildingsWithName:
		if tileMap.local_to_map(building.position) == cellI:
			return building
	
	assert(false, 'Unknown building at cell location ' + str(cellI))
	return null

func getEnemyTarget():
	# todo: set target building / architect / ...
	return architect

func setDifficulty(difficulty_: int):
	difficulty = difficulty_
	
func getDifficulty():
	return difficulty

func initGameOverWindow():
	if !is_queued_for_deletion():
		var gameOver = gameOverScene.instantiate()
		get_tree().root.add_child(gameOver)
		return gameOver
	else:
		# world should already be initialized
		return get_tree().root.get_node("GameOver")
