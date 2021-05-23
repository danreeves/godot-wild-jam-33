extends Control

var SkillButton = preload("res://UI/SkillBuyButton.tscn")

var currency = 1

func _ready() -> void:
	for spell in SpellStore.spells:
		if !SpellStore.purchased.has(spell):
			var btn = SkillButton.instance()
			var inst = spell.new()
			btn.texture = inst.texture
			btn.label = inst.spell_name
			btn.desc = inst.description
			btn.rect_size = Vector2(120, 120)
			var err = btn.connect("buy", self, "buy_spell", [spell])
			if err:
				print(err)
			$TextureRect/VBoxContainer/Buttons.add_child(btn)

func buy_spell(spell):
	if currency > 0:
		currency -= 1
		SpellStore.purchase(spell)
		for btn in $TextureRect/VBoxContainer/Buttons.get_children():
			if btn.label == spell.new().spell_name:
				btn.queue_free()
	$TextureRect/VBoxContainer/Currency.text = "Godly favours: %d" % currency

func _on_ContinueButton_button_up() -> void:
	if Globals.next_scene:
		var err = get_tree().change_scene_to(Globals.next_scene)
		Globals.next_scene = null
		if err:
			print(err)
	else:
		print("YOU FORGOT THE NEXT SCENE")
		var err = get_tree().change_scene("res://UI/TitleScreen.tscn")
		if err:
			print(err)
