extends KinematicBody2D

export(Globals.Elements) var element = Globals.Elements.None
export var speed = 100
var target: Node2D = null
var in_range = false

func _ready() -> void:
	var _err1 = $InCombat.connect("body_entered", self, "unit_enter_range")
	var _err2 = $InCombat.connect("body_exited", self, "unit_leave_range")

func _process(_delta: float) -> void:
	if !target:
		target = get_nearest_enemy()
	
func _physics_process(_delta: float) -> void:
	var velocity = Vector2.ZERO
	
	if target and not in_range:
		velocity = (target.position - self.position ).normalized() * speed
		
	velocity = move_and_slide(velocity)

func unit_enter_range(unit):
	if unit != self:
		in_range = true
		$AttackQueue.start_timer()
	
func unit_leave_range(_unit):
	target = null
	in_range = false

func get_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	var nearest = null
	var nearest_distance = 1000
	for enemy in enemies:
		var distance = self.position.distance_to(enemy.position)
		if distance < nearest_distance:
			nearest = enemy
			nearest_distance = distance
	return nearest

func get_target() -> Node2D:
	if in_range:
		return target
	return null
