@tool
extends Event

@onready var audio_stream_player := $"../../AudioStreamPlayer3D"
@onready var crank_reciever := $"../../OISCrankReceiver"
@onready var dialogue_system := get_tree().get_root().get_node("Main/DialogueSystem")
@onready var teleporter_manager := get_tree().get_root().get_node("Main/TeleporterManager")

@export var stop_flag : String

var text_dictionary : Array = []
var dialogue_progress_bool : bool
var text_array_size : int
var counter : int
var audio_file

func _on_event_started() -> void:
	crank_reciever.action_completed.connect(_on_ois_crank_receiver_action_completed)
	audio_file = load(custom_parameters["AudioSourceFile"])
	
func _on_ois_crank_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	if teleporter_manager.current_location in custom_parameters["EventLocations"] or custom_parameters["EventLocations"].size == 0:
		if !audio_stream_player.playing:
			audio_stream_player.stream = audio_file
			audio_stream_player.play()
			
			text_dictionary = custom_parameters["EventText"]["Text"]
			text_array_size = text_dictionary.size()
			# Print out the first line
			dialogue_system._load_string_array(text_dictionary, custom_parameters["EventText"]["Name"], null, false)
		
		await audio_stream_player.finished
	
	if oneshot:
		close_event()
