extends Node

var title_theme : AudioStream = preload("res://src/Assets/audio/music/01 - Title Theme.wav")
var in_game_theme_loop_1 : AudioStream = preload("res://src/Assets/audio/music/02 - In-Game Theme Loop 1.wav")
var in_game_theme_loop_2 : AudioStream = preload("res://src/Assets/audio/music/02 - In-Game Theme Loop 2.wav")
var in_game_theme_loop_3 : AudioStream = preload("res://src/Assets/audio/music/02 - In-Game Theme Loop 3.wav")
var current_stream : AudioStream
@onready var ambience_player: AudioStreamPlayer = $AmbiencePlayer

@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

var game_events : Array = ["QuestFindTheCodeToTheDesk_Done", "QuestContinueMakeNutribun_Done", "QuestFinishBedroom_Done"]

var current_stage = 0

func _ready() -> void:
	audio.stream = title_theme
	audio.play()
	ambience_player.play()

func start_title_music() -> void:
	audio.stop()
	ambience_player.play()
	audio.stream = title_theme
	audio.play()

func start_in_game_music() -> void:
	ambience_player.stop()
	audio.stop()
	audio.stream = in_game_theme_loop_1
	audio.play()

func check_music() -> void:
	var i = 0
	for e in game_events:
		if e in EventManager.completed_events:
			i += 1
	print(i)
	
	if i == 0:
		audio.stream = in_game_theme_loop_1
		audio.play()
	if i == 1:
		print("Changing Music to loop 2")
		audio.stream = in_game_theme_loop_2
		audio.play()
	elif i == 2:
		print("Changing Music to loop 3")
		audio.stream = in_game_theme_loop_3
		audio.play()
	else:
		audio.play()


func _on_audio_stream_player_finished() -> void:
	check_music()
