extends Event


func _on_event_started() -> void:
	print("Action Assemble Document Has Started Bro")


func _on_malakas_at_maganda_doc_document_completed() -> void:
	emit_signal("event_ended")
	close_event()
	QuestControl.add_active_quest("QuestCleanThePainting")
	QuestControl.update_active_quests()
