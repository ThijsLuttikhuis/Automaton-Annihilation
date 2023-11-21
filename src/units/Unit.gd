class_name Unit extends CharacterBody2D

var player: Node

var selectedActionPriority: int = 0

var moveSpeed: float = 0.0
var viewRange: float = 100.0
var radarRange: float = 100.0

func _ready():
	player = get_node('../../Player')
	var selectBox = player.get_node('SelectBox')
	selectBox.body_entered.connect(_on_body_entered)
	selectBox.body_exited.connect(_on_body_exited)
	
func _physics_process(_dt):
	var aq = get_node("ActionQueue")
	aq.update(self)
	
	if moveSpeed > 0.0:
		move_and_slide()


func _on_body_entered(body):
	player.addSelectedElement(body)

func _on_body_exited(body):
	player.removeSelectedElement(body)
	
