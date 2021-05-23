extends Node

const AbilityButton = preload("res://UI/AbilityButton.tscn")

export (int) var mana_regen_per_second = 5
export (int) var max_mana = 100
export (int) var mana = max_mana

var spells = [
	Heal.new(),
	ToGrass.new(),
	ToFire.new(),
	ToWater.new(),
	Blind.new(),
	Slow.new(),
	Haste.new(),
	Fear.new(),
]
var active_spell = null

onready var HUD = get_parent().find_node("HUD")

func _ready() -> void:
	var _err1 = $Timer.connect("timeout", self, "tick")
	var spells_container: HBoxContainer = HUD.find_node("Spells")
	for spell in spells:
		var button = AbilityButton.instance()
		button._texture = spell.texture
		button.label = spell.spell_name
		button.cooldown = spell.cooldown
		button.add_child(spell)
		spells_container.add_child(button)
		button.connect("clicked", self, "spell_primed")
		
func spell_primed(spell_name):
	for spell in spells:
		if spell.spell_name == spell_name:
			active_spell = spell
			
	if active_spell.mana_cost > mana:
		active_spell = null
			
	for button in HUD.find_node("Spells").get_children():
		var name = ""
		if active_spell:
			name = active_spell.spell_name
		if name == "" or button.label != name:
			button.deselect()
			
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 2:
		active_spell = null
		for button in HUD.find_node("Spells").get_children():
			button.deselect()

func active_spell_can_target(unit: Node) -> bool:
	var groups = unit.get_groups()
	
	var in_targetable_group = false
	var unit_is_valid = true
	
	if not active_spell:
		return false
	
	for group in groups:
		for targetable_group in active_spell.targetable_groups:
			if targetable_group == group:
				in_targetable_group = true
				
	if active_spell.has_method("is_unit_valid"):
		unit_is_valid = active_spell.is_unit_valid(unit)
				
	return in_targetable_group and unit_is_valid

func cast(target):
	if active_spell.has_method("cast"):
		active_spell.cast(target)
		mana = max(0, mana - active_spell.mana_cost)
		
		for button in HUD.find_node("Spells").get_children():
			if button.label == active_spell.spell_name:
				button.used()
	else:
		print(active_spell.spell_name + "HAS NO CAST METHOD")
		
	active_spell = null
	for button in HUD.find_node("Spells").get_children():
		button.deselect()

func tick():
	mana = min(max_mana, mana + mana_regen_per_second)
