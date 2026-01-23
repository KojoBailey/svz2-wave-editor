extends Node2D

@export var enemy_list: Array[Texture2D]

var enemy_button_scene = preload("res://scenes/enemy_button.tscn")
var enemy_buttons: HBoxContainer
const enemy_buttons_scale: float = 1.5

var list_element_scene = preload("res://scenes/list_element.tscn")
var list_element_size: Vector2
const wave_list_scale: float = 1.2
const wave_list_spacing: float = 20

var enemy_in_hand: Sprite2D

func _ready() -> void:
	enemy_buttons = $EnemyButtons
	enemy_buttons.scale = Vector2(enemy_buttons_scale, enemy_buttons_scale)

	for texture in enemy_list:
		create_button(texture)
	
	list_element_size = list_element_scene.instantiate().size

func _process(_delta: float) -> void:
	if enemy_in_hand != null:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			enemy_in_hand.position = get_global_mouse_position()
			var current_x = enemy_in_hand.position.x
			var foo = list_element_size.x + wave_list_spacing
			enemy_in_hand.position.x = 20 + floor(current_x / foo) * foo
		else:
			place_list_item(enemy_in_hand.texture)
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

func place_list_item(texture: Texture2D):
	var wave_list = $WaveList
	var list_element = list_element_scene.instantiate() as TextureButton
	list_element.texture_normal = texture
	list_element.scale = Vector2(wave_list_scale, wave_list_scale)
	list_element.position.x = 20 + wave_list.get_child_count() * (list_element.size.x + wave_list_spacing)
	list_element.position.y = 1080 - 40 - list_element.size.y
	wave_list.add_child(list_element)
