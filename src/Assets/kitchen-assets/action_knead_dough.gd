extends Event

func _on_knead_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	close_event()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
