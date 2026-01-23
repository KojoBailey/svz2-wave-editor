extends Area2D

var isDragging = false
var offset: float = 0

var spriteHalfSize: Vector2i

var leftBound: float
var rightBound: float

func _ready() -> void:
	spriteHalfSize = $Sprite2D.texture.get_size() * self.scale / 2
	leftBound = spriteHalfSize.x
	rightBound = get_viewport_rect().size.x - spriteHalfSize.x
	
	global_position = Vector2(rightBound, get_viewport_rect().size.y - spriteHalfSize.y)

func _process(_delta: float) -> void:
	if isDragging:
		var targetX = get_global_mouse_position().x - offset
		global_position.x = clamp(targetX, leftBound, rightBound)
		
	#var ratio = inverse_lerp(leftBound, rightBound, self.position.x)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			isDragging = true
			offset = get_global_mouse_position().x - global_position.x
		else:
			isDragging = false

func _input(event: InputEvent):
	if event is InputEventMouseButton and not event.pressed:
		isDragging = false
