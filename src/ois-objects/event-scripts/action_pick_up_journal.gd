extends Event


@onready var journal := get_parent()

func _on_event_started() -> void:
	journal.grabbed.connect(_on_ois_journal_grabbed)


func _on_ois_journal_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		emit_signal("event_ended")
	
		print("-----------------------------------------")
		print("EVENT ENDED: " + event_name)
		print("-----------------------------------------")
	
		QuestControl.add_active_quest("QuestNavigateHouse")
	
		QuestControl.update_active_quests()
		close_event()
