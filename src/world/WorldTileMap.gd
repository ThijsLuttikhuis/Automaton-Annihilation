class_name WorldTileMap extends TileMap

@onready var world: World = $".."

const nPathfindingThreads := 3
var pathfinder: Pathfinder

func _ready():
	pathfinder = Pathfinder.new(nPathfindingThreads)
	pathfinder. world = world

func _exit_tree():
	pathfinder.exit()
