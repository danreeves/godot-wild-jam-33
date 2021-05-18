extends Node2D
var Elements = Globals.Elements

var running = false
var duration = 2

var timer = 0

export(Texture) var sprite = null

func _ready() -> void:
	$Sprite.visible = false
	$Sprite.texture = sprite

func telegraph() -> void:
	$AnimationPlayer.play("Wiggle")
	$Sprite.visible = true

func done() -> void:
	get_parent().get_parent().move_away_from_player = false
	running = false
	$Sprite.visible = false
	$AnimationPlayer.stop()
	
func _process(delta: float) -> void:
	if running:
		timer += delta
		if timer >= duration:
			done()

func execute(unit: Node, owner: Node) -> void:
	owner.move_away_from_player = true
	running = true
	timer = 0
