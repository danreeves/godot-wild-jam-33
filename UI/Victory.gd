extends Control

var ShopScene = preload("res://Levels/Store.tscn")

func _ready() -> void:
	var _err1 = find_node("VictoryMenuNextLevelButton").connect("button_up", self, "next")
	var _err2 = find_node("VictoryMenuQuitButton").connect("button_up", self, "quit")

func next():
	visible = false
	var world = get_tree().get_root().get_node("World")
	if "next_scene" in world and world.next_scene:
		var shop = ShopScene.instance()
		Globals.next_scene = world.next_scene
		var err = get_tree().change_scene("res://Levels/Store.tscn")
		if err:
			print(err)
			
	else:
		var err = get_tree().change_scene("res://UI/TitleScreen.tscn")
		if err:
			print(err)

	get_tree().paused = false

func quit():
	get_tree().paused = false
	var err = get_tree().change_scene("res://UI/TitleScreen.tscn")
	if err:
		print(err)
