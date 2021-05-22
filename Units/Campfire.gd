extends Node2D

export var dead = false
export var move_away_from_player = false
export var camp = true

func _ready() -> void:
	$AnimatedSprite.play("idle")
