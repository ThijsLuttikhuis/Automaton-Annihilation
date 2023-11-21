class_name Unit extends CharacterBody2D

var selected: bool = false

# move
var moveSpeed: float

# combat stats 
var viewRange: float
var radarRange: float
var attackRange: float

func _physics_process(_dt):
	var aq = get_node("ActionQueue")
	aq.update(self);
	
	move_and_slide()
