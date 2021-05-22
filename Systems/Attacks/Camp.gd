extends Node2D

func _ready() -> void:
	pass

func telegraph() -> void:
	pass

func done() -> void:
	pass
	
func execute(_unit: Node, owner: Node) -> void:
	var sprite = owner.find_node("AnimatedSprite")
	var attack_queue = owner.find_node("AttackQueue")
	if attack_queue:
		attack_queue.stop()
	if sprite:
		sprite.play("camp")
	
func can_target_unit(unit) -> bool:
	if !unit:
		return false
		
	if "camp" in unit:
		return unit.camp
	
	return false
