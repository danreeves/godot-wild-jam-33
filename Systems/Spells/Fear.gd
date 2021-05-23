extends Node
class_name Fear

export (String) var spell_name = "Fear"
export (String) var description = "Scares enemies away from the Hero. They will return"
export (Array) var targetable_groups = ["Enemies"]
export (Texture) var texture = load("res://assets/UI/Fear.png")
export (int) var mana_cost = 10
export (int) var cooldown = 2
export (int) var blind_time = 4

var target_to_timer = {}

func cast(target):
	if "dead" in target and !target.dead:
		if "move_away_from_player" in target:
			target.move_away_from_player = true
			if target.find_node("AttackQueue"):
				var atkq = target.find_node("AttackQueue")
				if atkq.is_running:
					atkq.stop()
			if target_to_timer.has(target.get_instance_id()):
				target_to_timer[target.get_instance_id()].start()
			else:
				var timer = Timer.new()
				timer.wait_time = blind_time
				timer.connect("timeout", self, "timeout", [target, timer])
				target_to_timer[target.get_instance_id()] = timer
				add_child(timer)
				timer.start()

func is_unit_valid(unit):
	return "dead" in unit and !unit.dead

func timeout(target, timer):
	if "move_away_from_player" in target:
		target.move_away_from_player = false
	timer.queue_free()
	target_to_timer.erase(target.get_instance_id())
