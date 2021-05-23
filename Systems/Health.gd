extends Node2D

const DamageNumber = preload("res://UI/DamageNumber.tscn")

export var health: int = 100
var max_health = health

func _ready() -> void:
	max_health = health
	$HealthBar.visible = false
	
func set_max_health(new_health):
	if health == max_health:
		health = new_health
	max_health = new_health

func add_damage(num: int) -> void:
	var damage_number = DamageNumber.instance()
	damage_number.amount = num
	damage_number.position = Vector2(-13, -31)
	add_child(damage_number)
	health = health - num
	var animated_sprite = get_parent().find_node("AnimatedSprite")
	var attacking = false
	for anim in Globals.attack_anims:
		if animated_sprite.animation == anim:
			attacking = true
	if !attacking:
			animated_sprite.play("hit")
	if health <= 0:
		die()
	
func add_heal(num: int) -> void:
	var damage_number = DamageNumber.instance()
	damage_number.amount = num
	damage_number.position = Vector2(-13, -31)
	damage_number.heal = true
	add_child(damage_number)
	health = health + num

func die() -> void:
	get_parent().die()
	
func _process(_delta: float) -> void:
	$HealthBar.scale.x = max(0, float(health) / float(max_health))
	if health != max_health:
		$HealthBar.visible = true
