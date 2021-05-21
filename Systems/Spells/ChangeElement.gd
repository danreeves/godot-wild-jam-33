extends Object
class_name ChangeElement

export (String) var name = "Transmute"
export (Array) var targetable_groups = ["Enemies"]
export (Texture) var texture = load("res://button1.png")

func cast(target):
	if "element" in target:
		var elements = []
		for element in Globals.Elements.values():
			if element != target.element:
				elements.append(element)
		
		randomize()
		var new_element = elements[rand_range(0, elements.size())]
		target.set_element(new_element)
