extends Node2D
var Elements = Globals.Elements

export(Texture) var sprite = null
export var base_damage: int = 40
export(Globals.Elements) var element = Elements.None

var multiplier_lookup = [
	[Elements.Holy, Elements.Unholy, 1.5],
	[Elements.Unholy, Elements.Holy, 1.5],
	
	[Elements.Fire, Elements.Water, 1.5],
	[Elements.Water, Elements.Fire, 1.5],
	
	[Elements.Air, Elements.Earth, 1.5],
	[Elements.Earth, Elements.Air, 1.5],
]

func _ready() -> void:
	$Sprite.visible = false
	$Sprite.texture = sprite

func telegraph() -> void:
	$AnimationPlayer.play("Wiggle")
	$Sprite.visible = true

func done() -> void:
	$Sprite.visible = false
	$AnimationPlayer.stop()

func execute(unit: Node) -> void:
	var damage = base_damage
	var unit_element = unit.element
	var multiplier = 1
	
	for lookup in multiplier_lookup:
		match lookup:
			[element, unit_element, ..]:
				multiplier = lookup.back()
	
	damage = base_damage * multiplier
		
	unit.find_node("Health").add_damage(damage)
	done()
