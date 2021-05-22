extends KinematicBody2D

export(Globals.Elements) var element = Globals.Elements.None
export var speed = 100
export var move_to_player = false
export var move_away_from_player = false

onready var spell_manager = get_target().find_node("SpellManager")

func _ready() -> void:
	var _err1 = $InCombat.connect("body_entered", self, "unit_enter_range")
	var _err2 = $InCombat.connect("body_exited", self, "unit_leave_range")
	var _err3 = $AnimatedSprite.connect("animation_finished", self, "animation_finished")
	var _err4 = $ClickArea.connect("input_event", self, "input_event")
	move_child($AnimatedSprite, 1)
	set_element(element)

func get_target() -> Node2D:
	return get_tree().get_nodes_in_group("Player").front()

func unit_enter_range(unit: Node2D) -> void:
	if unit == get_target():
		move_to_player = false
		$AttackQueue.start_timer()

func unit_leave_range(unit: Node2D) -> void:
	if unit == get_target():
		$AttackQueue.stop()

func die() -> void:
	queue_free()

func is_element(elem) -> bool:
	return element == elem

func _process(_delta: float) -> void:
	$AnimatedSprite.flip_h = move_away_from_player
	
	if get_target().dead:
		$AttackQueue.stop()

func _physics_process(_delta: float) -> void:
	var velocity = Vector2.ZERO
	var target = get_target()
	
	if target and move_to_player:
		velocity = (target.position - self.position).normalized() * speed
	
	if target and move_away_from_player:
		velocity = (self.position - target.position).normalized() * speed * 1.2
		
	if velocity == Vector2.ZERO:
		if $AnimatedSprite.animation == "run":
			$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.play("run")
	
	velocity = move_and_slide(velocity)

func animation_finished() -> void:
	if $AnimatedSprite.animation == "attack":
		$AnimatedSprite.play("idle")
	
func input_event(_vp, event: InputEvent, _idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if spell_manager.active_spell_can_target(get_groups()):
			spell_manager.cast(self)

func set_element(ele):
	element = ele
	$ColorTween.interpolate_property(
		$AnimatedSprite, 
		"modulate", 
		$AnimatedSprite.modulate, 
		Globals.ElementColor[ele], 
		0.2, 
		Tween.TRANS_LINEAR
	)
	$ColorTween.start()
