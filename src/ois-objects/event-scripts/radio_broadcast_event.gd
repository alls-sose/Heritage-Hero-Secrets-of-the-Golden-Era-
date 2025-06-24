@tool
extends Event

@onready var audio_stream_player := $"../../AudioStreamPlayer3D"
@onready var crank_reciever := $"../../OISCrankReceiver"
@onready var dialogue_system := get_tree().get_root().get_node("Main/DialogueSystem")
@onready var teleporter_manager := get_tree().get_root().get_node("Main/TeleporterManager")
@onready var music_audio_stream_player := get_tree().get_root().get_node("Main/MusicHandler/MusicVolumeHandler")
@onready var radio_broadcasts: Node = $".."

@export var stop_flags : Array 

var text_dictionary : Array = []
var dialogue_progress_bool : bool
var text_array_size : int
var counter : int
var audio_file
var already_in_location: bool
var prio_change : bool 

func _on_event_started() -> void:
	prio_change = false
	teleporter_manager.location_changed.connect(_on_teleporter_manager_location_changed)
	crank_reciever.action_completed.connect(_on_ois_crank_receiver_action_completed)
	radio_broadcasts.prio_changed.connect(_on_prio_changed)
	EventManager.start_events.connect(_on_any_event_ended)
	audio_file = load(custom_parameters["AudioSourceFile"])
	
func _on_ois_crank_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	print("Play crank hint: "+self.name)
	if teleporter_manager.current_location.name in custom_parameters["EventLocations"] or custom_parameters["EventLocations"].size() == 0:
		
		if !audio_stream_player.playing:
			music_audio_stream_player.play("fade_music_out")
			audio_stream_player.stream = audio_file
			audio_stream_player.play()
			
			text_dictionary = custom_parameters["EventText"]["Text"]
			text_array_size = text_dictionary.size()
			# Print out the first line
			dialogue_system._load_string_array(text_dictionary, custom_parameters["EventText"]["Name"], null, false)
		
		await audio_stream_player.finished
		music_audio_stream_player.play("fade_music_in")
	
	if oneshot:
		close_event()

func _on_prio_changed() -> void:
	prio_change = true

func _on_any_event_ended() -> void:
	
	# Check if player is currently in a defined event location or if event can be played anywhere
	# If they are, change the prioritized event and notify the player.
	# If not, nothing happens.
	
	
	if teleporter_manager.current_location.name in custom_parameters["EventLocations"] or custom_parameters["EventLocations"].size() == 0:
		if !already_in_location:
			if get_parent().get_child_count() > 1:
				get_parent()._change_prio_event(self)
				#print(self.name+" "+"[radio] event prio: "+self.name)
				already_in_location = true
				
	# Then, check if the event should already be ended.
	# If the event is still the prioritized event, do not delete the event.
	for flag in stop_flags:
		if flag in EventManager.completed_events:
			if get_parent().prioritized_event != self.name:
				close_event()
				#print(self.name+" "+"[radio] event end: "+self.name)
				queue_free()
				prio_change = false

	
func _on_teleporter_manager_location_changed(location_name: Variant) -> void:
	# Check if the current event is supposed to be the current event after teleportation.
	# Useful when checking hints in different areas.
	# If not in location yet, notify the player once when they do arrive in the specified locations.
	#print(self.name+" "+"[radio] I AM TELEPORTING LOL: "+teleporter_manager.current_location.name)
	if get_parent().prioritized_event == self.name:
		already_in_location = true
	else:
		already_in_location = false
		
	for flag in stop_flags:
		if flag in EventManager.completed_events:
			if get_parent().prioritized_event != self.name:
				close_event()
				#print(self.name+" "+"[radio] event end via tp: "+self.name)
				queue_free()
				prio_change = false
	
	if custom_parameters["EventLocations"].size() != 0:
		if !already_in_location:
			if get_parent().prioritized_event != self.name:
				if teleporter_manager.current_location.name in custom_parameters["EventLocations"]:
					#print(self.name+" "+"[radio] prio changed via teleporter: "+self.name)
					get_parent()._change_prio_event(self)
					already_in_location = true
				else:
					already_in_location = false
	
	
		
