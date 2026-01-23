extends Node2D

var draggableScene = preload("res://scenes/draggable.tscn")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_texture_button_button_up() -> void:
	var draggable = draggableScene.instantiate()
	self.add_child(draggable)
