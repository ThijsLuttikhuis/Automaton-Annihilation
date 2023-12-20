extends Camera2D

const PAN_SPEED = 2.4
const ZOOM_FACTOR = 1.2
const ZOOM_LEVELS = 20
const MIN_ZOOM = pow(ZOOM_FACTOR, ZOOM_LEVELS/2.0)
const MAX_ZOOM = pow(ZOOM_FACTOR, -ZOOM_LEVELS/2.0)

var panStartMousePosition
var panStartCameraPosition

func _ready():
	panStartMousePosition = Vector2()
	panStartCameraPosition = Vector2()

func _process(_dt):
	if Input.is_action_just_pressed("ui_zoom_in"):
		if zoom.x < MIN_ZOOM:
			zoom = zoom * ZOOM_FACTOR

	if Input.is_action_just_pressed("ui_zoom_out"):
		if zoom.x > MAX_ZOOM:
			zoom = zoom / ZOOM_FACTOR
		
	if Input.is_action_just_pressed("ui_pan_camera"):
		panStartMousePosition = get_local_mouse_position()
		panStartCameraPosition = position
		
	if Input.is_action_pressed("ui_pan_camera"):
		var deltaMousePosition = get_local_mouse_position() - panStartMousePosition
		position = panStartCameraPosition + deltaMousePosition * PAN_SPEED
