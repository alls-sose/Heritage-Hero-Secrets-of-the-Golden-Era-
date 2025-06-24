@tool
class_name TutorialEvent
extends Event

var text_array : Array = []
var dialogue_progress_bool : bool
var text_array_size : int
var counter : int
var audio_file
@onready var audio_stream_player = $"../../TutorialStream"

@onready var dialogue_system := get_tree().get_root().get_node("Main/DialogueSystem")

func _on_event_started() -> void:
	audio_file = load(custom_parameters["AudioSourceFile"])
	text_array = custom_parameters["EventText"]["Text"]
	text_array_size = text_array.size()
	
	if !audio_stream_player.playing:
		audio_stream_player.stream = audio_file
		audio_stream_player.play()
	# Print out the first line
		dialogue_system._load_string_array(text_array, custom_parameters["EventText"]["Name"], null, false)
	#dialogue_system.dialogue_array_complete.connect(_on_tutorial_dialogue_finished)
	
		await audio_stream_player.finished
	
		emit_signal("event_ended")
		close_event()
		QuestControl.update_active_quests()

# Maybe connect a signal from the dialogue system to end the event
# Connect the signal in _on_event_started since the script already has a reference to the dialogue system
#func _on_tutorial_dialogue_finished() -> void:
	#await audio_stream_player.finished
	#
	#emit_signal("event_ended")
	#close_event()
	#QuestControl.update_active_quests()
