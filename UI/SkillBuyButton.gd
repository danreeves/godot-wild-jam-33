extends VBoxContainer

signal buy

export (Texture) var texture = null setget set_texture
export (String) var label = "" setget set_label
export (String) var desc = "" setget set_desc

func set_texture(t):
	texture = t
	$SkillButton/TextureRect.texture = texture
	
func set_label(l):
	label = l
	$SkillButton/Name.text = label

func set_desc(d):
	desc = d
	$Desc.text = desc

func _on_Button_button_up() -> void:
	emit_signal("buy")
