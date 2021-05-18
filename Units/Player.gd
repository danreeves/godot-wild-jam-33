extends KinematicBody2D

export(Globals.Elements) var element = Globals.Elements.None
export var speed = 100
var in_range = []
var unit_in_range_last_frame = false
export var dead = false

func _ready() -> void:
	var _err1 = $InCombat.connect("body_entered", self, "unit_enter_range")
	var _err2 = $InCombat.connect("body_exited", self, "unit_leave_range")
	var _err3 = $AnimatedSprite.connect("animation_finished", self, "animation_finished")

func _process(_delta: float) -> void:
	if dead:
		$AttackQueue.stop()
		return
		
	if !unit_in_range_last_frame and in_range.size() > 0:
		$AttackQueue.start_timer()
		unit_in_range_last_frame = true
	
	if in_range.size() == 0:
		$AttackQueue.stop()
		unit_in_range_last_frame = false
	
func _physics_process(_delta: float) -> void:
	if dead:
		return
		
	if $AnimatedSprite.animation == "attack":
		return
		
	var velocity = Vector2.ZERO
	var target = get_nearest_enemy()
	if target and in_range.size() == 0:
		$AnimatedSprite.play("run")
		velocity = (target.position - self.position).normalized() * speed
	elif $AnimatedSprite.animation == "run":
		$AnimatedSprite.play("idle")
	velocity = move_and_slide(velocity)

func unit_enter_range(unit):
	if unit != self:
		in_range.append(unit)
	
func unit_leave_range(unit):
	in_range.remove(in_range.find(unit))

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
	if in_range.size() > 0:
		return in_range.front()
	return null

func die() -> void:
	dead = true
	$AttackQueue.stop()
	$AnimatedSprite.play("die")

func animation_finished() -> void:
	if $AnimatedSprite.animation == "attack":
		$AnimatedSprite.play("idle")
		
