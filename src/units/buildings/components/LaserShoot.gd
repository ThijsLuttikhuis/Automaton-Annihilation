class_name LaserShoot extends Node2D

@onready var line: Line2D = $"Line2D"

var shooting: bool = false
var shootingTime: float = 0.35

func _physics_process(_dt):
	if shooting:
		var tween1 = create_tween()
		var tween2 = create_tween()
		var v2arr: PackedVector2Array = []
		v2arr.push_back(line.points[1])
		v2arr.push_back(line.points[1])
		tween1.tween_property(line, "points", v2arr, shootingTime)
		tween2.tween_property(line, "self_modulate", Color(1,1,1,0), shootingTime)
		shooting = false

func shoot(unit: DefenseBuilding, targetEnemy: FightUnit):
	line.clear_points()
	line.self_modulate = Color(1,1,1,1)
	line.add_point(unit.getShootPosition() - unit.position)
	line.add_point(targetEnemy.getShootPosition() - unit.position)
	targetEnemy.removeHP(unit.damage)
	shooting = true
