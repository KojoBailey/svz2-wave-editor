extends Node2D

@export var enemy_list: Array[Texture2D]

var dimensions: Vector2i
const margins := Vector2i(20, 40)

var wave_list: WaveList

var enemy_button_scene := preload("res://Elements/EnemyButtons/enemy_button.tscn")
var enemy_buttons: HBoxContainer
const enemy_buttons_scale: float = 1.5

func _ready() -> void:
	dimensions = DisplayServer.screen_get_size()
	
	wave_list = $WaveList
	wave_list.position = Vector2(margins.x, dimensions.y - margins.y)
	
	enemy_buttons = $EnemyButtons
	enemy_buttons.scale = Vector2(enemy_buttons_scale, enemy_buttons_scale)
	for texture in enemy_list:
		create_button(texture)
		
func _on_enemy_button_down(button: TextureButton) -> void:
	wave_list.create_drag_item(button.texture_normal)

func create_button(texture: Texture2D) -> void:
	var enemy_button := enemy_button_scene.instantiate() as TextureButton
	if enemy_button == null:
		push_error("Failed to cast enemy_button to TextureButton.")
		return
	
	enemy_button.texture_normal = texture
	enemy_button.button_down.connect(_on_enemy_button_down.bind(enemy_button))
	enemy_buttons.add_child(enemy_button)
