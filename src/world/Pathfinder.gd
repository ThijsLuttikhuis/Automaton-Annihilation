class_name Pathfinder

class PathfindingThread:
	var thread: Thread
	var semaphore: Semaphore
	var selfMutex: Mutex
	var shouldExit := false
	var busy := false
	var task: Callable
	var pathFinder: Pathfinder
	
	func _init(pathFinder_):
		selfMutex = Mutex.new()
		semaphore = Semaphore.new()
		thread = Thread.new()
		thread.start(threadFunction)
		pathFinder = pathFinder_
		
	func threadFunction():
		while true:
			semaphore.wait()
			
			pathFinder.updateAstarMutex.lock()
			var shouldExit_ = pathFinder.shouldExit
			pathFinder.updateAstarMutex.unlock()
			
			if shouldExit_:
				break
			
			selfMutex.lock()
			task.call()
			busy = false
			selfMutex.unlock()
	
	func isBusy():
		selfMutex.lock()
		var busy_ = busy
		selfMutex.unlock()
		return busy_
	
	func setTask(task_: Callable):
		selfMutex.lock()
		task = task_
		busy = true
		selfMutex.unlock()

const MAX_IMPOSSIBLE_PATHS_STORED: int = 50

var world: World

var mutex: Mutex
var pathfindingThreads: Array[PathfindingThread] = []

var nFindingPath := 0
var shouldExit := false

var updateAstarThread: Thread
var updateAstarSemaphore: Semaphore
var updateAstarMutex: Mutex
var pathfinderTasks: Array[Callable]

var aStarGrid: AStarGrid2D
var aStarUpdateTime: float = 0.0
var validPaths: Dictionary = {}
var impossiblePaths: Dictionary = {}

func _init(nThreads):
	aStarGrid = AStarGrid2D.new()
	aStarGrid.region = Rect2i(-200, -200, 400, 400)
	aStarGrid.cell_size = Vector2(16, 16)
	aStarGrid.offset = aStarGrid.cell_size * 0.5
	aStarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	aStarGrid.jumping_enabled = false
	aStarGrid.update()
	
	mutex = Mutex.new()
	updateAstarMutex = Mutex.new()
	updateAstarSemaphore = Semaphore.new()
	updateAstarThread = Thread.new()
	updateAstarThread.start(updateAStarThreadFunction)
	
	mutex = Mutex.new()
	for i in range(nThreads):
		pathfindingThreads.push_back(PathfindingThread.new(self))

func updateAStarThreadFunction():
	while true:
		updateAstarSemaphore.wait()
		
		updateAstarMutex.lock()
		var shouldExit_ = shouldExit
		updateAstarMutex.unlock()
		
		if shouldExit_:
			break
		
		updateAstarMutex.lock()
		var tasks = pathfinderTasks
		pathfinderTasks = []
		updateAstarMutex.unlock()
		mutex.lock()
		for task in tasks:
			for thread in pathfindingThreads:
				if !thread.isBusy():
					thread.setTask(task)
					thread.semaphore.post()

		mutex.unlock()

func addPathfinderTask(task: Callable):
	updateAstarMutex.lock()
	pathfinderTasks.push_back(task)
	updateAstarMutex.unlock()
	updateAstarSemaphore.post()

func updatePathfinderThread(cellI: Vector2i, solid: bool):
	mutex.lock()
	updateAstarMutex.lock()
	aStarGrid.set_point_solid(cellI, solid)
	if aStarGrid.is_dirty():
		aStarGrid.update()
		aStarUpdateTime = world.getTime()
		impossiblePaths = {}
		
	updateAstarMutex.unlock()
	mutex.unlock()

func updatePathfinder(cellI: Vector2i, solid: bool):
	var callFunction = Callable(self, "updatePathfinderThread").bind(cellI, solid)
	addPathfinderTask(callFunction)

func addImpossiblePath(unit: Unit, to: Vector2i):
	updateAstarMutex.lock()
	if impossiblePaths.has(unit):
		impossiblePaths[unit].push_back(to)
	else:
		impossiblePaths[unit] = [to]
	updateAstarMutex.unlock()

func addValidPath(unit: Unit, to: Vector2i, path: PackedVector2Array = []):
	updateAstarMutex.lock()
	if path.is_empty():
		validPaths[unit] = [to]
	else:
		validPaths[unit] = path
	updateAstarMutex.unlock()

func isPointSolid(location: Vector2i) -> bool:
	updateAstarMutex.lock()
	var isSolid = aStarGrid.is_point_solid(location)
	updateAstarMutex.unlock()
	return isSolid

func getLastUpdateTime() -> float:
	updateAstarMutex.lock()
	var updateTime = aStarUpdateTime
	updateAstarMutex.unlock()
	return updateTime

func getPath(unit: Unit, from: Vector2i, to: Vector2i):
	if isValidPath(unit, to):
		return getValidPath(unit)
	
	if isImpossiblePath(unit, to):
		return []
	
	if isPointSolid(to):
		var dPoints = getNeighbourPointsToTry(to)
		var newPointFound = false
		for point in dPoints:
			if !isPointSolid(point):
				to = point
				newPointFound = true
				break
		if ~newPointFound:
			addImpossiblePath(unit, to)
			return []
	
	addValidPath(unit, to)
	var callFunction = Callable(self, "getPointPathThreadFunction").bind(unit, from, to)
	addPathfinderTask(callFunction)
	return []

func getPointPathThreadFunction(unit: Unit, from: Vector2i, to: Vector2i):
	mutex.lock()
	var pathFound = aStarGrid.get_point_path(from, to)
	mutex.unlock()
	if pathFound.is_empty():
		addImpossiblePath(unit, to)
	else:
		addValidPath(unit, to, pathFound)
	
	return pathFound

func isValidPath(unit: Unit, to: Vector2i):
	updateAstarMutex.lock()
	var isValid := false
	if validPaths.has(unit):
		var unitPath = validPaths[unit]
		if unitPath[-1] == world.tileMap.map_to_local(to):
			isValid = true
	
	updateAstarMutex.unlock()
	return isValid

func getValidPath(unit: Unit):
	updateAstarMutex.lock()
	var unitPath = validPaths[unit]
	updateAstarMutex.unlock()
	return unitPath

func isImpossiblePath(unit: Unit, to: Vector2i):
	updateAstarMutex.lock()
	var isImpossible := false
	if impossiblePaths.has(unit):
		var unitPaths = impossiblePaths[unit]
		if unitPaths.size() > MAX_IMPOSSIBLE_PATHS_STORED:
			var keys = impossiblePaths.keys()
			unitPaths.erase(keys[0])
		
		for path in unitPaths:
			if path == to:
				isImpossible = true
				break
	
	updateAstarMutex.unlock()
	return isImpossible

func getNeighbourPointsToTry(cell: Vector2i):
	var dPoints: Array[Vector2i] = [
		cell + Vector2i(-1, 0),
		cell + Vector2i(1, 0),
		cell + Vector2i(0, -1),
		cell + Vector2i(0, 1)
		]
	return dPoints

func exit():
	mutex.lock()
	updateAstarMutex.lock()
	shouldExit = true
	updateAstarMutex.unlock()
	mutex.unlock()
	
	updateAstarSemaphore.post()
	for pfThread in pathfindingThreads:
		pfThread.semaphore.post()
	
	updateAstarThread.wait_to_finish()
	for pfThread in pathfindingThreads:
		pfThread.thread.wait_to_finish()
