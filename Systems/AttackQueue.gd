extends Node2D

export var wait_time: float = 3
export var cooldown: float = 0.2

var attacks = []
var current_attack = null

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child.is_in_group("Attack"):
			attacks.append(child)
	var _err1 = $Timer.connect("timeout", self, "on_timer_end")
	$Timer.wait_time = wait_time
	
	var _err2 = $Cooldown.connect("timeout", self, "start_timer")
	$Cooldown.wait_time = cooldown

func _process(_delta: float) -> void:
	var target = get_parent().get_target()
	
	if !target:
		stop()
	
	if not $Timer.is_stopped():
		var progress = ($Timer.wait_time - $Timer.time_left) / $Timer.wait_time
		$Progress.scale.x = progress
	else:
		$Progress.scale.x = 0		

func stop() -> void:
	$Timer.stop()
	if current_attack and current_attack.has_method("done"):
		current_attack.done()
	current_attack = null

func start_timer() -> void:
	randomize()
	attacks.shuffle()
	current_attack = attacks.front()
	$Progress.scale.x = 0
	$Timer.start()
	
	if current_attack.has_method("telegraph"):
		current_attack.telegraph()

func on_timer_end() -> void:
	if current_attack.has_method("execute"):
		var target = get_parent().get_target()
		current_attack.execute(target, get_parent())
	$Cooldown.start()
