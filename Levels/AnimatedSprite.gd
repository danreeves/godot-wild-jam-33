extends Node2D

signal animation_finished

export (String) var animation = "idle"
export (Color) var _modulate = Color(1, 1, 1, 1)
export (bool) var flip_h = false
export (Color) var default_color = null

func _ready() -> void:
	var _err1 = $AnimatedSprite1.connect("animation_finished", self, "animation_finished")

func animation_finished():
	animation = $AnimatedSprite1.animation
	emit_signal("animation_finished")
	
func play(anim: String):
	animation = anim
	for child in get_children():
		if child is AnimatedSprite:
			child.play(animation)

func stop():
	for child in get_children():
		if child is AnimatedSprite:
			child.stop()

func _process(_delta: float) -> void:
	for child in get_children():
		if child is AnimatedSprite:
			child.flip_h = flip_h
	$AnimatedSprite3.modulate = _modulate
	$AnimatedSprite1.modulate = _modulate
