extends Node
class_name ToGrass

export (String) var spell_name = "Grass"
export (Array) var targetable_groups = ["Enemies"]
export (Texture) var texture = load("res://assets/UI/ToGrass.png")
export (int) var mana_cost = 10
export (int) var cooldown = 1

func cast(target):
	if "dead" in target and !target.dead:
		if "element" in target:
			target.set_element(Globals.Elements.Grass)

func is_unit_valid(unit):
	return "dead" in unit and !unit.dead
