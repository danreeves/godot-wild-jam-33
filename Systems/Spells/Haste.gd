extends Node
class_name Haste

export (String) var spell_name = "Haste"
export (String) var description = "Increases Hero’s attack rate and movement speed"
export (Array) var targetable_groups = ["Player", "Enemies"]
export (Texture) var texture = load("res://assets/UI/Haste.png")
export (int) var mana_cost = 10
export (int) var cooldown = 3.7
export (int) var blind_time = 4

var target_to_timer = {}

func cast(target):
	if "dead" in target and !target.dead:
		if "hasted" in target:
			target.hasted = true
			
		target.speed = target.speed * 2
		target.wait_time = target.wait_time / 2
		
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
	if "hasted" in target:
		target.hasted = false
	target.speed = target.speed / 2
	target.wait_time = target.wait_time * 2
	timer.queue_free()
	target_to_timer.erase(target.get_instance_id())
