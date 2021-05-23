extends Control

func _ready() -> void:
	var _err1 = find_node("TitleButtonPlay").connect("button_up", self, "play")
	var _err2 = find_node("TitleButtonQuit").connect("button_up", self, "quit")
	
	$Title.rect_position = Vector2($Title.rect_position.x, -$Title.rect_size.y)
	$VBoxContainer.modulate.a = 0.0
	var _err5 = $Tween.connect("tween_all_completed", self, "animate_menu")
	var _err6 = $Tween2.connect("tween_all_completed", self, "menu_ready")
	call_deferred("animate_title")

func animate_title():
	$Tween.interpolate_property(
		$Title, 
		"rect_position", 
		$Title.rect_position, 
		Vector2($Title.rect_position.x, 40), 
		2.0, 
		Tween.TRANS_ELASTIC
	)
	$Tween.start()

func animate_menu():
	$Tween2.interpolate_property(
		$VBoxContainer, 
		"modulate", 
		$VBoxContainer.modulate, 
		Color(1, 1, 1, 1), 
		.5, 
		Tween.TRANS_LINEAR
	)
	$Tween2.start()

func menu_ready():
	pass
	
func quit():
	get_tree().quit()

func play():
	var err = get_tree().change_scene("res://Levels/Level1.tscn")
	if err:
		print(err)
