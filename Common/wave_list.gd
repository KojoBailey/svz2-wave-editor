extends Node2D

class_name WaveList

const item_scale: float = 1
const item_scale_vec2 := Vector2(item_scale, item_scale)
const preview_scale: float = 0.7
const spacing: float = 10

var items: Node2D
var preview: ColorRect
var scroll_bar: Node2D

var item_scene := preload("res://Elements/WaveList/list_element.tscn")
var item_size: Vector2
var item_total_width: float
var list: Array[TextureButton]

var is_dragging_item: bool = false
var item_in_hand: Sprite2D
var hand_index: int
var previous_hand_index: int

func _ready() -> void:
	var element: TextureButton = instantiate_item()
	item_size = element.size
	item_total_width = item_size.x + spacing
	
	items = $Items
	items.scale = item_scale_vec2
	
	initialize_preview()

func assign_scroll_bar(_scroll_bar: Node2D) -> void:
	scroll_bar = _scroll_bar
	scroll_bar.position = self.position
	scroll_bar.set_width(1880)  # [TODO] Make not hard-coded.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_dragging()
		
func _process(_delta: float) -> void:
	self.position.x = (list.size() * item_total_width * item_scale - scroll_bar.width) * -scroll_bar.get_percent()
	
func _on_item_button_down(item: TextureButton) -> void:
	var index: int = calculate_index(item.position.x)
	list.remove_at(index)
	create_drag_item(item.texture_normal)
	items.remove_child(item)
	item.queue_free()

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
	preview = $Items/Preview
	preview.size = Vector2(item_size.y, item_size.y)
	preview.pivot_offset = preview.size / 2 # centre anchor
	preview.scale = Vector2(preview_scale, preview_scale)
	preview.position.y = -item_size.y
	preview.visible = false

func handle_dragging() -> void:
	if not is_dragging_item: return
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		item_in_hand.position = get_local_mouse_position()
		print(get_local_mouse_position())
		hand_index = calculate_index(item_in_hand.position.x)
		item_in_hand.position -= item_size / 2  # purely visual
	
		if previous_hand_index != hand_index:
			on_drag_index_change()
	else:
		on_item_drop()
		
func create_drag_item(texture: Texture2D) -> void:
	item_in_hand = Sprite2D.new()
	item_in_hand.centered = false
	item_in_hand.texture = texture
	item_in_hand.scale = Vector2(1, 1)
	reset_positions()
	previous_hand_index = -1
	add_child(item_in_hand)
	is_dragging_item = true
	handle_dragging()

func place_item(texture: Texture2D, index: int) -> void:
	var element: TextureButton = instantiate_item()
	element.texture_normal = texture
	element.scale = Vector2(1, 1)
	element.position = Vector2(calculate_local_x(index), -element.size.y)
	items.add_child(element)
	element.button_down.connect(_on_item_button_down.bind(element))
	list.insert(index, element)
	reset_positions()
	scroll_bar.set_data_width(list.size() * item_total_width)
	
func set_positions(index: int) -> void:
	for i in range(list.size()):
		create_item_tween(list[i], calculate_local_x(i + 1 if i >= index else i))
	
	preview.position.x = calculate_local_x(index)

func reset_positions() -> void:
	for i in range(list.size()):
		create_item_tween(list[i], calculate_local_x(i))
			
func create_item_tween(item: TextureButton, target_x: float) -> PropertyTweener:
	return create_tween().tween_property(item, "position:x", target_x, 0.15) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

func calculate_index(local_x: float) -> int:
	return clamp(floor(local_x / item_total_width), 0, list.size())

func calculate_local_x(index: int) -> float:
	return index * item_total_width

func show_item_preview(_show: bool) -> void:
	preview.visible = _show
