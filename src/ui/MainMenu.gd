class_name MainMenu extends Node2D

var worldScene = preload("res://src/world/World.tscn")

func startWorld():
	if !is_queued_for_deletion():
		var world = worldScene.instantiate()
		get_tree().root.add_child(world)
		return world
	else:
		# world should already be initialized
		return get_tree().root.get_node("World")

func onClickPlay():
	$"HUD/ColorRect".hide()
	$"HUD/SelectDifficulty".show()

func onClickSettings():
	print("settings")

func onClickSandboxMode():
	var world = startWorld()
	world.defaultEnergyStorage = 100000
	world.updateEnergyStorage()
	world.addEnergy(100000)
	world.setDifficulty(0)
	
	var architect = world.get_node("Units/Architect")
	architect.inventory.add('Iron Plate', 10000)
	architect.inventory.add('Copper Plate', 1000)
	architect.inventory.add('Stone', 1000)
	
	queue_free()

func onClickEasyMode():
	var world = startWorld()
	world.addEnergy(1000)
	world.setDifficulty(1)
	
	var architect = world.get_node("Units/Architect")
	architect.inventory.add('Iron Plate', 60)
	architect.inventory.add('Stone', 20)
	architect.inventory.add('Copper Plate', 10)
	
	queue_free()

func onClickHardMode():
	var world = startWorld()
	world.addEnergy(1000)
	world.setDifficulty(2)
	
	var architect = world.get_node("Units/Architect")
	architect.inventory.add('Iron Plate', 40)
	architect.inventory.add('Stone', 10)
	
	queue_free()

func onClickSelectDifficultyBack():
	$"HUD/SelectDifficulty".hide()
	$"HUD/ColorRect".show()
