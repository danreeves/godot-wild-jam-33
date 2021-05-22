extends TextureRect

onready var HUD = get_parent().get_parent().get_parent()
onready var player = HUD.get_parent()
onready var spell_manager = player.find_node("SpellManager")

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	rect_scale.x = float(spell_manager.mana) / float(spell_manager.max_mana)
