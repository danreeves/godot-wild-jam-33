extends Node2D

export (int) var amount = 0
export (float) var lifetime = 0.3
export (bool) var heal = false

export (Color) var red = null
export (Color) var green = null
export (Color) var no_damage = null

func _ready() -> void:
	
	var color = red.to_html(false)
	if heal:
		color = green.to_html(false)
	if amount == 0:
		amount = "MISS"
		color = no_damage.to_html(false)
	
	$RichTextLabel.bbcode_text = "[color=#%s][wave amp=150 freq=-0.5]%s" % [color, amount]
	
	$Timer.wait_time = lifetime
	var _err1 = $Timer.connect("timeout", self, "end")
	
func end():
	queue_free()
