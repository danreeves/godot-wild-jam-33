extends KinematicBody2D

export(Globals.Elements) var element = Globals.Elements.None
export var speed = 100
var in_range = []
var unit_in_range_last_frame = false
export var dead = false

onready var spell_manager = $SpellManager

func _ready() -> void:
	var _err1 = $InCombat.connect("body_entered", self, "unit_enter_range")
	var _err2 = $InCombat.connect("body_exited", self, "unit_leave_range")
	var _err3 = $AnimatedSprite.connect("animation_finished", self, "animation_finished")
	var _err4 = $ClickArea.connect("input_event", self, "input_event")

func _process(_delta: float) -> void:
	if dead:
		$AttackQueue.stop()
		return
		
	if !unit_in_range_last_frame and get_in_range().size() > 0:
		$AttackQueue.start_timer()
		unit_in_range_last_frame = true
		
	if get_in_range().size() == 0:
		$AttackQueue.stop()
		unit_in_range_last_frame = false
	
	if !get_nearest_enemy():
		$AnimatedSprite.play("camp")
		
	# bobbus wrote this code
	var size = 1 + position.y * 0.002
	scale = Vector2(size, size)
	
func _physics_process(_delta: float) -> void:
	if dead:
		return
		
	if $AnimatedSprite.animation == "attack":
		return
		
	var velocity = Vector2.ZERO
	var target = get_nearest_enemy()
	if target and get_in_range().size() == 0:
		$AnimatedSprite.play("run")
		velocity = (target.position - self.position).normalized() * speed
	elif target and get_in_range().size() > 0:
		$AnimatedSprite.play("combat")
	elif $AnimatedSprite.animation == "run":
		$AnimatedSprite.play("idle")
	velocity = move_and_slide(velocity)

func unit_enter_range(unit):
	if unit != self:
		in_range.append(unit)
	
func unit_leave_range(unit):
	var index = in_range.find(unit)
	if index >= 0:
		in_range.remove(index)

func get_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	var nearest = null
	var nearest_distance = 1000
	for enemy in enemies:
		if !enemy.dead:
			var distance = self.position.distance_to(enemy.position)
			if distance < nearest_distance:
				nearest = enemy
				nearest_distance = distance
	return nearest

func get_in_range() -> Array:
	var not_dead = []
	for enemy in in_range:
		if !enemy.dead:
			not_dead.append(enemy)
	return not_dead

func get_target() -> Node2D:
	var in_range_not_dead = get_in_range()
	if in_range_not_dead.size() > 0:
		return in_range_not_dead.front()
	return null

func die() -> void:
	dead = true
	$AttackQueue.stop()
	$AnimatedSprite.play("die")

func animation_finished() -> void:
	if $AnimatedSprite.animation == "attack":
		$AnimatedSprite.play("idle")
		
func input_event(_vp, event: InputEvent, _idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if spell_manager.active_spell_can_target(get_groups()):
			spell_manager.cast(self)
