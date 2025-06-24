extends Event

func _on_bowl_main_mix_4_done() -> void:
	print("MIX 4 DONE")
	close_event()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
	QuestControl.add_active_quest("QuestContinueMakeNutribun")
	QuestControl.update_active_quests()
