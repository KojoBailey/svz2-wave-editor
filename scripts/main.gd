extends Node2D

@export var enemy_list: Array[Texture2D]

const margins = Vector2i(20, 40)

var enemy_button_scene = preload("res://scenes/enemy_button.tscn")
var enemy_buttons: HBoxContainer
const enemy_buttons_scale: float = 1.5

var list_element_scene = preload("res://scenes/list_element.tscn")
var list_element_size: Vector2
const wave_list_scale: float = 1.2
const wave_list_spacing: float = 20
var list_element_total_width: float
var wave_list: Array[TextureButton]

var enemy_in_hand: Sprite2D
var previous_hand_x: float

func _ready() -> void:
	enemy_buttons = $EnemyButtons
	enemy_buttons.scale = Vector2(enemy_buttons_scale, enemy_buttons_scale)

	for texture in enemy_list:
		create_button(texture)
	
	list_element_size = list_element_scene.instantiate().size
	list_element_total_width = (list_element_size.x + wave_list_spacing) * wave_list_scale

func _process(_delta: float) -> void:
	if enemy_in_hand != null:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			enemy_in_hand.position = get_global_mouse_position()
			var index = calculate_list_index(enemy_in_hand.position.x)
			print(index)
			enemy_in_hand.position.x = calculate_list_x(index)
			previous_hand_x = enemy_in_hand.position.x
		else:
			place_list_item(enemy_in_hand.texture, enemy_in_hand.position.x)
			enemy_in_hand.queue_free()
			enemy_in_hand = null

func create_button(texture: Texture2D) -> void:
	var enemy_button = enemy_button_scene.instantiate() as TextureButton
	enemy_button.texture_normal = texture
	enemy_button.button_down.connect(_on_enemy_button_down.bind(enemy_button))
	enemy_buttons.add_child(enemy_button)

func _on_enemy_button_down(button: TextureButton) -> void:
	enemy_in_hand = Sprite2D.new()
	enemy_in_hand.centered = false
	enemy_in_hand.texture = button.texture_normal
	enemy_in_hand.scale = Vector2(wave_list_scale, wave_list_scale)
	self.add_child(enemy_in_hand)

func place_list_item(texture: Texture2D, drop_x: float):
	var list_element = list_element_scene.instantiate() as TextureButton
	list_element.texture_normal = texture
	list_element.scale = Vector2(wave_list_scale, wave_list_scale)
	list_element.position.x = calculate_list_x(wave_list.size())
	list_element.position.y = 1080 - margins.y - list_element.size.y
	$WaveList.add_child(list_element)
	
	if wave_list.size() >= 4:
		for item in wave_list.slice(2):
			item.position.x += calculate_list_x(1)
		list_element.position.x = calculate_list_x(2)
		wave_list.insert(2, list_element)
	else:
		wave_list.push_back(list_element)

func calculate_list_index(x: float) -> int:
	return max(0, floor((x - margins.x) / list_element_total_width))

func calculate_list_x(index: int) -> float:
	return index * list_element_total_width + margins.x
