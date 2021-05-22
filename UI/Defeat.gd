extends Control

func _ready() -> void:
	var _err1 = find_node("DefeatMenuRestartButton").connect("button_up", self, "restart")
	var _err2 = find_node("DefeatMenuQuitButton").connect("button_up", self, "quit")

func restart():
	visible = false
	get_tree().reload_current_scene()
	get_tree().paused = false

func quit():
	get_tree().paused = false
	var err = get_tree().change_scene("res://UI/TitleScreen.tscn")
	if err:
		print(err)
