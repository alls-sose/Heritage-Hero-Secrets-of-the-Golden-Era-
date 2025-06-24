extends Event

func _on_bowl_main_split_done() -> void:
	close_event()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
