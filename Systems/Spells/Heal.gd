extends Node
class_name Heal

export (String) var spell_name = "Heal"
export (String) var description = ""
export (Array) var targetable_groups = ["Player"]
export (Texture) var texture = load("res://assets/UI/Heal.png")
export (int) var mana_cost = 20
export (int) var cooldown = 1

func cast(target):
	var hp = target.find_node("Health")
	if hp:
		hp.add_heal(10)
