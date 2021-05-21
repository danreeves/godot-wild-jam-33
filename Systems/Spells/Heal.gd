extends Object
class_name Heal

export (String) var name = "Heal"
export (Array) var targetable_groups = ["Player"]
export (Texture) var texture = load("res://button1.png")

func cast(target):
	var hp = target.find_node("Health")
	if hp:
		hp.add_heal(10)
