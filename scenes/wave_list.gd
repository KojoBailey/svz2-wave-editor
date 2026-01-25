extends Node2D

class_name WaveList

const element_scale: float = 1.2
const element_scale2 := Vector2(element_scale, element_scale)
const preview_scale: float = 0.7
const spacing: float = 10

var rect: ColorRect

var list_element_scene := preload("res://scenes/list_element.tscn")
var element_size: Vector2
var element_total_width: float
var list: Array[TextureButton]

func _ready() -> void:
	var element: TextureButton = instantiate_element()
	element_size = element.size
	element_total_width = element_size.x + spacing
	
	rect = $ColorRect
	add_child(rect)
	rect.size = Vector2(element_size.y, element_size.y)
	rect.pivot_offset = rect.size / 2 # centre anchor
	rect.scale = Vector2(preview_scale, preview_scale)
	rect.position.y = -element_size.y
	rect.visible = false
	
	scale = element_scale2

func instantiate_element() -> TextureButton:
	var result := list_element_scene.instantiate() as TextureButton
	if result == null:
		push_error("Failed to cast element to TextureButton")
	return result

func place_item(texture: Texture2D, index: int) -> void:
	var element: TextureButton = instantiate_element()
	element.texture_normal = texture
	element.scale = Vector2(1, 1)
	element.position.y = -element.size.y
	add_child(element)
	list.insert(index, element)
	reset_positions()

func calculate_index(x: float) -> int:
	return min(max(0, floor((x - position.x) / (element_total_width * scale.x))), list.size())

func calculate_x(index: int) -> float:
	return index * element_total_width + position.x

func set_positions(index: int) -> void:
	var i: int = 0
	for item in list:
		if i >= index:
			item.position.x = calculate_x(i + 1)
		else:
			item.position.x = calculate_x(i)
		i += 1
	
	rect.position.x = calculate_x(index)

func reset_positions() -> void:
	var i: int = 0
	for item in list:
		item.position.x = calculate_x(i)
		i += 1

func show_item_preview(_show: bool) -> void:
	rect.visible = _show
