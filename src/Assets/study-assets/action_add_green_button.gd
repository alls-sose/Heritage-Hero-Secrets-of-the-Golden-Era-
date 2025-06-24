extends Event

func _on_printing_press_button_added() -> void:
	close_event()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
