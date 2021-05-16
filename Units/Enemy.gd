extends Node2D

export(Globals.Elements) var element = Globals.Elements.None

func _ready() -> void:
	var _err1 = $InCombat.connect("body_entered", self, "unit_enter_range")
	var _err2 = $InCombat.connect("body_exited", self, "unit_leave_range")

func get_target() -> Node2D:
	return get_tree().get_nodes_in_group("Player").front()

func unit_enter_range(unit: Node2D) -> void:
	if unit == get_target():
		$AttackQueue.start_timer()

func unit_leave_range(unit: Node2D) -> void:
	if unit == get_target():
		$AttackQueue.stop()

func die() -> void:
	queue_free()

func is_element(elem) -> bool:
	return element == elem
