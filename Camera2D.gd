extends Camera2D

onready var player = get_parent().find_node("Player")

func _process(_delta: float) -> void:
	offset.x = player.position.x + 300
