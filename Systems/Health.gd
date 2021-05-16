extends Node2D

export var health: int = 100
var max_health = health

func _ready() -> void:
	max_health = health
	$HealthBar.visible = false

func add_damage(num: int) -> void:
	health = health - num
	if health <= 0:
		die()
	
func add_heal(num: int) -> void:
	health = health + num

func die() -> void:
	get_parent().die()
	
func _process(_delta: float) -> void:
	$HealthBar.scale.x = float(health) / float(max_health)
	if health != max_health:
		$HealthBar.visible = true
