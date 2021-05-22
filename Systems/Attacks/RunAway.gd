extends Node2D
var Elements = Globals.Elements

export var duration = 2

export(Texture) var sprite = null

func _ready() -> void:
	$Sprite.visible = false
	$Sprite.texture = sprite

func telegraph() -> void:
	$AnimationPlayer.play("Wiggle")
	$Sprite.visible = true

func done() -> void:
	$Sprite.visible = false
	$AnimationPlayer.stop()
	
func execute(_unit: Node, owner: Node) -> void:
	owner.move_away_from_player = true

func after_duration(_unit: Node, owner: Node) -> void:
	owner.move_away_from_player = false
	
func can_target_unit(_unit) -> bool:
	return true
