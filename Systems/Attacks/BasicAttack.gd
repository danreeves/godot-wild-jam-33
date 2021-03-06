extends Node2D
var Elements = Globals.Elements

export(Texture) var sprite = null
export var base_damage: int = 40
export(Globals.Elements) var element = Elements.None
export(AudioStream) var audio = null

var multiplier_lookup = [
	[Elements.Fire, Elements.Water, 0.5],
	[Elements.Water, Elements.Fire, 1.5],
	
	[Elements.Water, Elements.Grass, 0.5],
	[Elements.Grass, Elements.Water, 1.5],
	
	[Elements.Grass, Elements.Fire, 0.5],
	[Elements.Fire, Elements.Grass, 1.5],
	
	[Elements.Fire, Elements.Fire, 0.8],
	[Elements.Water, Elements.Water, 0.8],
	[Elements.Grass, Elements.Grass, 0.8],
]

func _ready() -> void:
	$Sprite.visible = false
	$Sprite.texture = sprite
	if audio:
		$AudioStreamPlayer.stream = audio
	
func telegraph() -> void:
	$AnimationPlayer.play("Wiggle")
	$Sprite.visible = true

func done() -> void:
	$Sprite.visible = false
	$AnimationPlayer.stop()
	
func can_target_unit(unit) -> bool:
	if !unit:
		return false
	var health = unit.find_node("Health")
	if health:
		return true
	return false

func execute(unit: Node, owner: Node) -> void:
	var damage = base_damage
	var unit_element = Globals.Elements.None
	if "element" in unit:
		unit_element = unit.element
	var multiplier = 1
	
	for lookup in multiplier_lookup:
		match lookup:
			[element, unit_element, ..]:
				multiplier = lookup.back()
	
	damage = base_damage * multiplier
	
	if "blind" in owner and owner.blind:
		damage = 0 
	
	var health = unit.find_node("Health")
	if health:
		health.add_damage(damage)
		
	$AudioStreamPlayer.pitch_scale = rand_range(0.9, 1.1)
	$AudioStreamPlayer.play()
	done()
