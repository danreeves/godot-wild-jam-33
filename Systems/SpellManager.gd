extends Node

const AbilityButton = preload("res://UI/AbilityButton.tscn")

var spells = [
	Heal.new(),
	Heal2.new(),
	ChangeElement.new()
]
var active_spell = null

onready var HUD = get_parent().find_node("HUD")

func _ready() -> void:
	var spells_container: HBoxContainer = HUD.find_node("Spells")
	for spell in spells:
		var button = AbilityButton.instance()
		button._texture = spell.texture
		button.label = spell.name
		spells_container.add_child(button)
		button.connect("clicked", self, "spell_primed")
		
func spell_primed(spell_name):
	for spell in spells:
		if spell.name == spell_name:
			active_spell = spell
			
	for button in HUD.find_node("Spells").get_children():
		if button.label != spell_name:
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
	else:
		print(active_spell.name + "HAS NO CAST METHOD")
		
	active_spell = null
	for button in HUD.find_node("Spells").get_children():
		button.deselect()
