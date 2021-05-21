extends TextureRect

export(Texture) var _texture = null
export (String) var label = ""

signal clicked(spell_name)

func _ready() -> void:
	texture = _texture
	$Label.text = label
	var _err1 = connect("mouse_entered", self, "mouse_entered")
	var _err2 = connect("mouse_exited", self, "mouse_exited")
	var _err3 = connect("gui_input", self, "gui_input")

func _process(_delta: float) -> void:
	pass
#	$Progress.rect_size.x -= delta * 10
#	if $Progress.rect_size.x <= 0:
#		$Progress.rect_size.x = 60

func mouse_entered() -> void:
	pass
	
func mouse_exited() -> void:
	pass

func gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			emit_signal("clicked", label)
			select()

func select():
	$Selected.visible = true
	
func deselect():
	$Selected.visible = false
