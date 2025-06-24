extends Event

func _on_bowl_main_mix_2_done() -> void:
	print("MIX 2 DONE")
	close_event()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
