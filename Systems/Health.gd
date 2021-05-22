extends Node2D

const DamageNumber = preload("res://UI/DamageNumber.tscn")

export var health: int = 100
var max_health = health

func _ready() -> void:
	max_health = health
	$HealthBar.visible = false

func add_damage(num: int) -> void:
	var damage_number = DamageNumber.instance()
	damage_number.amount = num
	damage_number.position = Vector2(-13, -31)
	add_child(damage_number)
	health = health - num
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
