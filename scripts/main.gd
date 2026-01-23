extends Node2D

@export var enemy_list: Array[Texture2D]

var enemy_button_scene = preload("res://scenes/enemy_button.tscn")
var draggable_scene = preload("res://scenes/draggable.tscn")

func _ready() -> void:
	for i in range(enemy_list.size() - 1):
		create_button(enemy_list[i], i)
	
func create_button(texture: Texture2D, index: int) -> void:
	var enemy_button = enemy_button_scene.instantiate() as TextureButton
	enemy_button.texture_normal = texture
	enemy_button.position.x = index * (enemy_button.size.x + 40)
	enemy_button.button_up.connect(_on_enemy_button_up.bind(enemy_button))
	
	self.add_child(enemy_button)

func _on_enemy_button_up(button: TextureButton) -> void:
	var draggable = draggable_scene.instantiate()
	draggable.set_texture(button.texture_normal) as Node2D
	self.add_child(draggable)
