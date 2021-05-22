extends Node2D

var is_running = false
export var wait_time: float = 3
export var cooldown: float = 0.2

var attacks = []
var current_attack = null
var queued_stop_after_duration = false

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child.is_in_group("Attack"):
			attacks.append(child)
	var _err1 = $Timer.connect("timeout", self, "on_timer_end")
	$Timer.wait_time = wait_time
	
	var _err2 = $Cooldown.connect("timeout", self, "on_cooldown_end")
	$Cooldown.wait_time = cooldown
	
	var _err3 = $Duration.connect("timeout", self, "on_duration_end")

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
	if !$Duration.is_stopped() and $Duration.time_left > 0:
		queued_stop_after_duration = true
		return
	$Timer.stop()
	if current_attack and current_attack.has_method("done"):
		current_attack.done()
	current_attack = null
	is_running = false

func start_timer() -> void:
	if is_running:
		return
	randomize()
	attacks.shuffle()
	var valid_attacks = []
	for attack in attacks:
		if attack.can_target_unit(get_parent().get_target()):
			valid_attacks.append(attack)
	
	if valid_attacks.size() > 0:
		current_attack = valid_attacks.front()
	else:
		return
		
	$Progress.scale.x = 0
	$Timer.start()
	if "duration" in current_attack:
		$Duration.wait_time = current_attack.duration
	else:
		$Duration.wait_time = 0.0001
	is_running = true
	
	if current_attack.has_method("telegraph"):
		current_attack.telegraph()
		
func on_cooldown_end() -> void:
	is_running = false
	start_timer()

func on_timer_end() -> void:
	if current_attack.has_method("execute"):
		var target = get_parent().get_target()
		if target:
			current_attack.execute(target, get_parent())
			
	if current_attack:
		if "element" in current_attack:
			var anim = Globals.ElementAnim[current_attack.element]
			get_parent().find_node("AnimatedSprite").play(anim)
		else:
			get_parent().find_node("AnimatedSprite").play("attack")
		$Duration.start()

func on_duration_end() -> void:
	if current_attack.has_method("after_duration"):
		var target = get_parent().get_target()
		current_attack.after_duration(target, get_parent())
		
	if queued_stop_after_duration:
		queued_stop_after_duration = false
		stop()
	else:
		$Cooldown.start()
