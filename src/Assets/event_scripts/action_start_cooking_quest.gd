@tool
extends Event



var text_array : Array = []
var dialogue_progress_bool : bool
var text_array_size : int
var counter : int


@onready var dialogue_system := get_tree().get_root().get_node("Main/DialogueSystem")

func _on_event_started() -> void:
	emit_signal("event_ended")
	QuestControl.add_active_quest("QuestMakeNutribun")
	close_event()
	QuestControl.update_active_quests()
	
