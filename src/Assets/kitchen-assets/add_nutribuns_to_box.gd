extends Event

func _on_nutribon_box_all_nutri_in_box() -> void:
	close_event()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
