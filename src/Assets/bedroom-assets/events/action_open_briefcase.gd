extends Event


func _on_briefcase_lock_lock_solved() -> void:
	emit_signal("event_ended")
	close_event()
	QuestControl.update_active_quests()
