extends KinematicBody2D

export(Globals.Elements) var element = Globals.Elements.None
export var speed = 100
export var move_to_player = false
export var move_away_from_player = false

onready var spell_manager = get_target().find_node("SpellManager")

export var dead = false

func _ready() -> void:
	var _err1 = $InCombat.connect("body_entered", self, "unit_enter_range")
	var _err2 = $InCombat.connect("body_exited", self, "unit_leave_range")
	var _err3 = $AnimatedSprite.connect("animation_finished", self, "animation_finished")
	var _err4 = $ClickArea.connect("input_event", self, "input_event")
	move_child($AnimatedSprite, 1)
	set_element(element)
	$AnimatedSprite.play("idle")

func get_target() -> Node2D:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		return players.front()
	return null

func unit_enter_range(unit: Node2D) -> void:
	if unit == get_target():
		move_to_player = false
		if !dead:
			$AttackQueue.start_timer()

func unit_leave_range(unit: Node2D) -> void:
	if unit == get_target():
		$AttackQueue.stop()

func die() -> void:
	dead = true
	$AttackQueue.stop()
	$AnimatedSprite.stop()
	$AnimatedSprite.play("die")
	$AnimatedSprite.flip_h = false
	set_element(Globals.Elements.None)
	$Hitbox.disabled = true

func is_element(elem) -> bool:
	return element == elem

func _process(_delta: float) -> void:
	if dead: 
		return
	
	# bobbus wrote this code
	var size = 1 + position.y * 0.002
	scale = Vector2(size, size)
	
	if get_target().dead:
		$AttackQueue.stop()

func _physics_process(_delta: float) -> void:
	if dead:
		return
		
	var velocity = Vector2.ZERO
	var target = get_target()
	
	if target and move_to_player:
		velocity = (target.position - self.position).normalized() * speed
	
	if target and move_away_from_player:
		velocity = (self.position - target.position).normalized() * speed * 1.2
		
	if velocity == Vector2.ZERO:
		if $AnimatedSprite.animation == "run" \
		or $AnimatedSprite.animation == "flee":
			$AnimatedSprite.play("idle")
	elif move_away_from_player:
		$AnimatedSprite.play("flee")
	else:
		$AnimatedSprite.play("run")
		
	$AnimatedSprite.flip_h = target.position.x < position.x
	if move_away_from_player:
		$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	
	velocity = move_and_slide(velocity)

func animation_finished() -> void:
	if ($AnimatedSprite.animation == "attack" or $AnimatedSprite.animation == "hit") and !dead:
		$AnimatedSprite.play("idle")
	
func input_event(_vp, event: InputEvent, _idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if spell_manager.active_spell_can_target(self):
			spell_manager.cast(self)

func set_element(ele):
	element = ele
	var color = Globals.ElementColor[ele]
	if ele == Globals.Elements.None and "default_color" in $AnimatedSprite:
		color = $AnimatedSprite.default_color
	
	var property = "modulate"
	if "_modulate" in $AnimatedSprite:
		property = "_modulate"
	
	$ColorTween.interpolate_property(
		$AnimatedSprite, 
		property, 
		$AnimatedSprite.modulate, 
		color, 
		0.2, 
		Tween.TRANS_LINEAR
	)
	$ColorTween.start()
