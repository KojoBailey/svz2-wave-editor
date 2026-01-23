extends Area2D

## Interface

func set_texture(texture: Texture2D):
	$Sprite2D.texture = texture

## Implementation

var is_dragging = false
var offset: float = 0

var left_bound: float
var right_bound: float

func _ready() -> void:
	var sprite_half_size = $Sprite2D.texture.get_size() * self.scale / 2
	left_bound = sprite_half_size.x
	right_bound = get_viewport_rect().size.x - sprite_half_size.x
	
	self.global_position = Vector2(right_bound, get_viewport_rect().size.y - sprite_half_size.y)

func _process(_delta: float) -> void:
	if is_dragging:
		var target_x = get_global_mouse_position().x - offset
		self.global_position.x = clamp(target_x, left_bound, right_bound)
		
	#var ratio = inverse_lerp(left_bound, right_bound, self.position.x)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			offset = get_global_mouse_position().x - global_position.x
		else:
			is_dragging = false

func _input(event: InputEvent):
	if event is InputEventMouseButton and not event.pressed:
		is_dragging = false
