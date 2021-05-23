extends Node
class_name Blind

export (String) var spell_name = "Blind"
export (String) var description = "Makes enemies miss attacks for a duration"
export (Array) var targetable_groups = ["Enemies"]
export (Texture) var texture = load("res://assets/UI/Blind.png")
export (int) var mana_cost = 10
export (int) var cooldown = 2
export (int) var blind_time = 4

var target_to_timer = {}

func cast(target):
	if "dead" in target and !target.dead:
		if "blind" in target:
			target.blind = true
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
	if "blind" in target:
		target.blind = false
	timer.queue_free()
	target_to_timer.erase(target.get_instance_id())
