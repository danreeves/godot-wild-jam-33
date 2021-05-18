extends TextureRect

export(Texture) var _texture = null

func _ready() -> void:
	texture = _texture
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")

func _process(delta: float) -> void:
	$Progress.rect_size.x -= delta * 10
	if $Progress.rect_size.x <= 0:
		$Progress.rect_size.x = 60

func mouse_entered() -> void:
	print("mouse entered")
	
func mouse_exited() -> void:
	print("mouse exited")
