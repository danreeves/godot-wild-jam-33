extends Control

func _ready() -> void:
	var _err1 = find_node("PauseMenuResumeButton").connect("button_up", self, "resume")
	var _err2 = find_node("PauseMenuQuitButton").connect("button_up", self, "quit")

func resume():
	visible = false
	get_tree().paused = false

func quit():
	get_tree().paused = false
	var err = get_tree().change_scene("res://UI/TitleScreen.tscn")
	if err:
		print(err)
