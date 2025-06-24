extends Event


func _on_tray_all_dough_ready() -> void:
	close_event()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
