extends Event


func _on_teleporter_manager_leave_mansion() -> void:
	emit_signal("event_ended")
	close_event()
	QuestControl.update_active_quests()
