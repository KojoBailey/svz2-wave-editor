extends Node2D

class_name WaveList

const item_scale: float = 1.2
const item_scale_vec2 := Vector2(item_scale, item_scale)
const preview_scale: float = 0.7
const spacing: float = 10

var preview: ColorRect

var item_scene := preload("res://scenes/list_element.tscn")
var item_size: Vector2
var item_total_width: float
var list: Array[TextureButton]

var is_dragging_item: bool = false
var item_in_hand: Sprite2D
var hand_index: int
var previous_hand_index: int

func _ready() -> void:
	scale = item_scale_vec2
	
	var element: TextureButton = instantiate_item()
	item_size = element.size
	item_total_width = item_size.x + spacing
	
	initialize_preview()
	
func _process(_delta: float) -> void:
	handle_dragging()
	
func _on_item_button_down(item: TextureButton) -> void:
	var index: int = calculate_index(item.position.x)
	create_drag_item(item.texture_normal)
	list.remove_at(index)
	remove_child(item)

func on_drag_index_change() -> void:
	set_positions(hand_index)
	show_item_preview(true)
	previous_hand_index = hand_index

func on_item_drop() -> void:
	place_item(item_in_hand.texture, hand_index)
	item_in_hand.queue_free()
	show_item_preview(false)
	is_dragging_item = false
	
func instantiate_item() -> TextureButton:
	var result := item_scene.instantiate() as TextureButton
	if result == null:
		push_error("Failed to cast element to TextureButton.")
	return result

func initialize_preview() -> void:
	preview = $Preview
	preview.size = Vector2(item_size.y, item_size.y)
	preview.pivot_offset = preview.size / 2 # centre anchor
	preview.scale = Vector2(preview_scale, preview_scale)
	preview.position.y = -item_size.y
	preview.visible = false

func handle_dragging() -> void:
	if not is_dragging_item: return
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		item_in_hand.global_position = get_global_mouse_position()
		hand_index = calculate_index(item_in_hand.global_position.x)
		item_in_hand.global_position -= item_size / 2  # purely visual
	
		if previous_hand_index != hand_index:
			on_drag_index_change()
	else:
		on_item_drop()
		
func create_drag_item(texture: Texture2D) -> void:
	item_in_hand = Sprite2D.new()
	item_in_hand.centered = false
	item_in_hand.texture = texture
	item_in_hand.scale = item_scale_vec2
	reset_positions()
	previous_hand_index = -1
	add_child(item_in_hand)
	is_dragging_item = true

func place_item(texture: Texture2D, index: int) -> void:
	var element: TextureButton = instantiate_item()
	element.texture_normal = texture
	element.scale = Vector2(1, 1)
	element.position.y = -element.size.y
	add_child(element)
	element.button_down.connect(_on_item_button_down.bind(element))
	list.insert(index, element)
	reset_positions()
	
func set_positions(index: int) -> void:
	var i: int = 0
	for item in list:
		if i >= index:
			item.position.x = calculate_x(i + 1)
		else:
			item.position.x = calculate_x(i)
		i += 1
	
	preview.position.x = calculate_x(index)

func reset_positions() -> void:
	var i: int = 0
	for item in list:
		item.position.x = calculate_x(i)
		i += 1

func calculate_index(x: float) -> int:
	return min(max(0, floor((x - position.x) / (item_total_width * scale.x))), list.size())

func calculate_x(index: int) -> float:
	return index * item_total_width + position.x

func show_item_preview(_show: bool) -> void:
	preview.visible = _show
