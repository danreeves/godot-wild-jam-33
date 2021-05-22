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
	$AnimatedSprite.play("idle")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_node("HUD").find_node("Pause").visible = true
		get_tree().paused = true
	
	if dead:
		$AttackQueue.stop()
		return
		
	if $AnimatedSprite.animation == "camp":
		$AttackQueue.stop()
		return
		
	var target = get_nearest_enemy()
		
	if !unit_in_range_last_frame and is_in_range(target):
		$AttackQueue.start_timer()
		unit_in_range_last_frame = true
		
	if !is_in_range(target):
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
	
	if $AnimatedSprite.animation == "camp":
		$AttackQueue.stop()
		return
		
	for anim in Globals.attack_anims:
		if $AnimatedSprite.animation == anim:
			return
		
	var velocity = Vector2.ZERO
	var target = get_nearest_enemy()
	
	if target and !is_in_range(target):
		$AnimatedSprite.play("run")
		velocity = (target.position - self.position).normalized() * speed
	elif target and is_in_range(target):
		$AnimatedSprite.play("combat")
	elif $AnimatedSprite.animation == "run":
		$AnimatedSprite.play("idle")
	
	if velocity != Vector2.ZERO:
		$AnimatedSprite.flip_h = velocity.x < 0
		
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
	var nearest_distance = 999999999999999999
	var num_dead_enemies = 0
	for enemy in enemies:
		if !enemy.dead:
			var distance = self.position.distance_to(enemy.position)
			if distance < nearest_distance:
				nearest = enemy
				nearest_distance = distance
		else:
			num_dead_enemies += 1
	
	if enemies.size() == num_dead_enemies:
		nearest = get_tree().get_nodes_in_group("Goal").front()
	
	return nearest

func is_in_range(unit) -> bool:
	if in_range.has(unit):
		if "dead" in unit and !unit.dead \
		and "move_away_from_player" in unit and !unit.move_away_from_player:
			return true
	return false
	
func get_target() -> Node2D:
	var nearest = get_nearest_enemy()
	if is_in_range(nearest):
		return nearest
	return null

func die() -> void:
	dead = true
	$AttackQueue.stop()
	$AnimatedSprite.play("die")

func animation_finished() -> void:
	for anim in Globals.attack_anims:
		if $AnimatedSprite.animation == anim:
			$AnimatedSprite.play("idle")
	
	if $AnimatedSprite.animation == "camp":
		get_node("HUD").find_node("Victory").visible = true
		pass
		
	if $AnimatedSprite.animation == "die":
		get_node("HUD").find_node("Defeat").visible = true
		pass

func input_event(_vp, event: InputEvent, _idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if spell_manager.active_spell_can_target(self):
			spell_manager.cast(self)
