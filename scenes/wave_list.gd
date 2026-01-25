extends Node2D

class_name WaveList

const element_scale: float = 1.2
const element_scale2 := Vector2(element_scale, element_scale)
const spacing: float = 10

var list_element_scene := preload("res://scenes/list_element.tscn")
var element_size: Vector2
var element_total_width: float
var list: Array[TextureButton]

func _ready() -> void:
	var element: TextureButton = instantiate_element()
	element_size = element.size
	element_total_width = (element_size.x + spacing) * element_scale

func instantiate_element() -> TextureButton:
	var result := list_element_scene.instantiate() as TextureButton
	if result == null:
		push_error("Failed to cast element to TextureButton")
	
	return result

func place_item(texture: Texture2D, index: int) -> void:
	var element: TextureButton = instantiate_element()
	element.texture_normal = texture
	element.scale = element_scale2
	element.position.y -= element.size.y * element_scale
	add_child(element)
	list.insert(index, element)
	reset_positions()

func calculate_index(x: float) -> int:
	return min(max(0, floor((x - position.x) / element_total_width)), list.size())

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

func reset_positions() -> void:
	var i: int = 0
	for item in list:
		item.position.x = calculate_x(i)
		i += 1
