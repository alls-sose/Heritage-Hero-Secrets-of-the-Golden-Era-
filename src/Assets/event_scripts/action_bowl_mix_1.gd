extends Event

func _on_bowl_main_mix_1_done() -> void:
	print("MIX 1 DONE")
	close_event()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
