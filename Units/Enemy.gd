extends KinematicBody2D

export(Globals.Elements) var element = Globals.Elements.None
export var speed = 100
export var move_to_player = false
export var move_away_from_player = false

func _ready() -> void:
	var _err1 = $InCombat.connect("body_entered", self, "unit_enter_range")
	var _err2 = $InCombat.connect("body_exited", self, "unit_leave_range")
	var _err3 = $AnimatedSprite.connect("animation_finished", self, "animation_finished")
	move_child($AnimatedSprite, 0)

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
		
