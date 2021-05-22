extends Camera2D

onready var player = get_parent().find_node("Player")

func _process(delta: float) -> void:
	offset.x = player.position.x + (OS.window_size.x / 3.0)
