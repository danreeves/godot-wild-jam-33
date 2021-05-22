extends TextureRect

export(Texture) var _texture = null
export (String) var label = ""
export (int) var cooldown = 1

var selected = false

signal clicked(spell_name)

func _ready() -> void:
	texture = _texture
	$Label.text = label
	$Cooldown.wait_time = cooldown
	var _err1 = connect("mouse_entered", self, "mouse_entered")
	var _err2 = connect("mouse_exited", self, "mouse_exited")
	var _err3 = connect("gui_input", self, "gui_input")

func _process(_delta: float) -> void:
	$Progress.rect_scale.x = $Cooldown.time_left / $Cooldown.wait_time

func mouse_entered() -> void:
	$Selected.visible = true
	$Selected.modulate = Color(1, 1, 1, 0.6)
	
func mouse_exited() -> void:
	if !selected:
		$Selected.visible = false
		
	$Selected.modulate = Color(1, 1, 1, 1)

func gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			if $Cooldown.is_stopped():
				select()
				emit_signal("clicked", label)
			
func used():
	$Cooldown.start()

func select():
	selected = true
	$Selected.visible = true
	
func deselect():
	selected = false
	$Selected.visible = false
