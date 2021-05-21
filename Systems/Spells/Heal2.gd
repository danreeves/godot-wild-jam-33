extends Object
class_name Heal2

export (String) var name = "Heal2"
export (Array) var targetable_groups = ["Enemies"]
export (Texture) var texture = load("res://button1.png")
func cast(target):
	var hp = target.find_node("Health")
	if hp:
		hp.add_heal(20)
