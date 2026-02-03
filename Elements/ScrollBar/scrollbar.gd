extends Node2D

const height: float = 30

var width: float
var child_scale: float
var data_width: float

var back: ColorRect
var front: ColorRect

var is_dragging: bool = false
var previous_mouse_x: float

func _ready() -> void:
	back = $Back
	front = $Front

func set_width(new_width: float) -> void:
	width = new_width
	back.size.x = new_width
	if width >= data_width:
		set_data_width(0)

func set_child_scale(_scale: float) -> void:
	child_scale = _scale

func set_data_width(new_data_width: float) -> void:
	data_width = new_data_width * child_scale
	front.size.x = width / data_width * width if data_width > width else width

func _on_front_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		is_dragging = true
		
func _process(_delta: float) -> void:
	previous_mouse_x = get_local_mouse_position().x

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if not is_dragging: return
	
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			front.position.x += get_local_mouse_position().x - previous_mouse_x
			front.position.x = clamp(front.position.x, 0, width - front.size.x)
		else:
			is_dragging = false

func get_percent() -> float:
	return front.position.x / (width - front.size.x) if width != front.size.x else 0.0
