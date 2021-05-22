extends Control

func _ready() -> void:
	var _err1 = find_node("TitleButtonQuit").connect("button_up", self, "quit")
	var _err2 = find_node("TitleButtonPlay").connect("button_up", self, "play")
	
func quit():
	get_tree().quit()

func play():
	var err = get_tree().change_scene("res://Levels/Level1.tscn")
	if err:
		print(err)
