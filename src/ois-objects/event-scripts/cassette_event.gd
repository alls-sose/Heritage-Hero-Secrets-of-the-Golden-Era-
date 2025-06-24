@tool
class_name CassetteEvent
extends Event


@onready var audio_stream_player := $"../../AudioStreamPlayer3D"
@onready var dialogue_system := get_tree().get_root().get_node("Main/DialogueSystem")
@onready var cassette_player: Node3D = $"../../cassette player"

var audio_file

var text_array : Array = []
var dialogue_progress_bool : bool
var text_array_size : int
var counter : int

func _on_event_started() -> void:
	audio_file = load(custom_parameters["AudioSourceFile"])


func _on_cassette_player_play() -> void:
	if !audio_stream_player.playing:
		audio_stream_player.stream = audio_file
		audio_stream_player.play()
		
		text_array = custom_parameters["EventText"]["Text"]
		text_array_size = text_array.size()
		# Print out the first line
		dialogue_system._load_string_array(text_array, custom_parameters["EventText"]["Name"], null, false)
		
	await audio_stream_player.finished
	
	close_event()
	audio_file = load(custom_parameters["AudioSourceFile"])
	
