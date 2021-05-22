extends Node

const AbilityButton = preload("res://UI/AbilityButton.tscn")

export (int) var mana_regen_per_second = 5
export (int) var max_mana = 100
export (int) var mana = max_mana

var spells = [
	Heal.new(),
	Heal2.new(),
	ChangeElement.new()
]
var active_spell = null

onready var HUD = get_parent().find_node("HUD")

func _ready() -> void:
	var _err1 = $Timer.connect("timeout", self, "tick")
	var spells_container: HBoxContainer = HUD.find_node("Spells")
	for spell in spells:
		var button = AbilityButton.instance()
		button._texture = spell.texture
		button.label = spell.name
		button.cooldown = spell.cooldown
		spells_container.add_child(button)
		button.connect("clicked", self, "spell_primed")
		
func spell_primed(spell_name):
	for spell in spells:
		if spell.name == spell_name:
			active_spell = spell
			
	if active_spell.mana_cost > mana:
		active_spell = null
			
	for button in HUD.find_node("Spells").get_children():
		var name = ""
		if active_spell:
			name = active_spell.name
		if name == "" or button.label != name:
			button.deselect()
			
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 2:
		active_spell = null
		for button in HUD.find_node("Spells").get_children():
			button.deselect()

func spell_activated(target):
	print(target)

func active_spell_can_target(groups: Array) -> bool:
	if not active_spell:
		return false
	
	for group in groups:
		for targetable_group in active_spell.targetable_groups:
			if targetable_group == group:
				return true
		
	return false

func cast(target):
	if active_spell.has_method("cast"):
		active_spell.cast(target)
		mana = max(0, mana - active_spell.mana_cost)
		
		for button in HUD.find_node("Spells").get_children():
			if button.label == active_spell.name:
				button.used()
	else:
		print(active_spell.name + "HAS NO CAST METHOD")
		
	active_spell = null
	for button in HUD.find_node("Spells").get_children():
		button.deselect()

func tick():
	mana = min(max_mana, mana + mana_regen_per_second)
