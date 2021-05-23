extends TextureRect

var spell_manager = null

func _ready() -> void:
	var node = self
	while node.name != "Player":
		node = node.get_parent()
	
	spell_manager = node.find_node("SpellManager")
	
func _process(_delta: float) -> void:
	if spell_manager:
		rect_scale.x = float(spell_manager.mana) / float(spell_manager.max_mana)
