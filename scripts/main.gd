extends Node2D

@export var enemy_list: Array[Texture2D]

const margins = Vector2i(20, 40)

var enemy_button_scene := preload("res://scenes/enemy_button.tscn")
var enemy_buttons: HBoxContainer
const enemy_buttons_scale: float = 1.5

var wave_list: WaveList

var enemy_in_hand: Sprite2D
var previous_hand_index: int

func _ready() -> void:
	enemy_buttons = $EnemyButtons
	enemy_buttons.scale = Vector2(enemy_buttons_scale, enemy_buttons_scale)
	for texture in enemy_list:
		create_button(texture)
		
	previous_hand_index = -1
	
	wave_list = $WaveList
	wave_list.position = Vector2(margins.x, 1080 - margins.y)

func _process(_delta: float) -> void:
	handle_enemy_dragging()

func handle_enemy_dragging() -> void:
	if enemy_in_hand == null: return
		
	enemy_in_hand.position = get_global_mouse_position()
	var index: int = wave_list.calculate_index(enemy_in_hand.position.x)
	enemy_in_hand.position -= wave_list.element_size / 2
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if previous_hand_index != index:
			wave_list.set_positions(index)
		previous_hand_index = index
		wave_list.show_item_preview(true)
	else:
		wave_list.place_item(enemy_in_hand.texture, index)
		previous_hand_index = -1
		enemy_in_hand.queue_free()
		enemy_in_hand = null
		wave_list.show_item_preview(false)

func create_button(texture: Texture2D) -> void:
	var enemy_button := enemy_button_scene.instantiate() as TextureButton
	if enemy_button == null:
		push_error("Failed to cast enemy_button to TextureButton.")
		return
	
	enemy_button.texture_normal = texture
	enemy_button.button_down.connect(_on_enemy_button_down.bind(enemy_button))
	enemy_buttons.add_child(enemy_button)

func _on_enemy_button_down(button: TextureButton) -> void:
	enemy_in_hand = Sprite2D.new()
	enemy_in_hand.centered = false
	enemy_in_hand.texture = button.texture_normal
	enemy_in_hand.scale = wave_list.element_scale2
	self.add_child(enemy_in_hand)
