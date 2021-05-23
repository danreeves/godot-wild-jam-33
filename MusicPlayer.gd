extends Node

var songs = [
	load("res://soundeffects/belch.mp3"),
	load("res://music/Blacksmith.mp3"),
	load("res://music/Bonfire.mp3"),
	load("res://music/Medieval.mp3"),
	load("res://music/Mjolnir.mp3"),
]

var index = 0

func _ready() -> void:
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.stream = songs[index]
	audio_stream_player.volume_db = -7
	songs.erase(0)
	call_deferred("add_audio_player", audio_stream_player)

func add_audio_player(audio_stream_player):
	get_tree().get_root().add_child(audio_stream_player)
	audio_stream_player.play()
	var err = audio_stream_player.connect("finished", self, "next", [audio_stream_player])
	if err:
		print(err)

func next(audio_stream_player):
	audio_stream_player.stop()
	
	index += 1
	if index > songs.size():
		index = 0
	
	audio_stream_player.stream = songs[index]
	audio_stream_player.play()
